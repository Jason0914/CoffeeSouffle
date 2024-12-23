$(document).ready(function () {
    // 生成或獲取客戶識別碼
    let clientId = localStorage.getItem('clientId');
    if (!clientId) {
        clientId = 'client_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        localStorage.setItem('clientId', clientId);
    }

    // 展開/收縮按鈕邏輯
    $(document).on("click", ".toggle-details", function (event) {
        event.stopPropagation();
        const parent = $(this).closest(".list-group-item");
        const details = parent.find(".item-details");

        if (details.is(":visible")) {
            details.slideUp();
            $(this).text("展開");
        } else {
            $(".item-details").slideUp();
            $(".toggle-details").text("展開");
            details.slideDown();
            $(this).text("收起");
        }
    });

    // 點擊圖片切換描述顯示/隱藏
    $(document).on("click", ".meal-thumbnail", function () {
        const description = $(this).closest(".list-item").find(".meal-description");
        description.slideToggle();
    });

    // 定義訂單數據，加入 clientId
    let orderData = JSON.parse(localStorage.getItem("orderData")) || {
        tableNumber: null,
        total: 0,
        orderTime: null,
        items: [],
        clientId: clientId
    };

    // 監聽選擇框的變化事件
    $(document).on("change", ".form-select", function () {
        orderData.tableNumber = $(this).val();
        saveOrderData();
    });

    // 渲染購物車
    function renderCart() {
        let cartItems = $("#cart-items");
        cartItems.empty();
        let totalPrice = 0;
        orderData.items.forEach((item, index) => {
            totalPrice += item.price * item.quantity;
            cartItems.append(`
                <tr>
                    <td class="text-center py-2">${item.orderName}</td>
                    <td class="text-center py-2">${item.price}</td>
                    <td class="text-center py-2">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <button class="btn btn-outline-secondary btn-sm change-quantity" data-index="${index}" data-action="decrease">-</button>
                            </div>
                            <input type="text" class="form-control text-center quantity-input" value="${item.quantity}" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm change-quantity" data-index="${index}" data-action="increase">+</button>
                            </div>
                        </div>
                    </td>
                    <td class="text-center py-2">NT$${item.price * item.quantity}</td>
                    <td class="text-center py-2">
                        <button type="button" class="btn btn-outline-danger btn-sm remove-item" data-index="${index}">刪除</button>
                    </td>
                </tr>
            `);
        });
        $("#total-amount").text(`總金額: NT$${totalPrice}`);
        $("#table-number").text(`桌號: ${orderData.tableNumber}`);
        orderData.totalPrice = totalPrice;
        saveOrderData();
    }

    // 將訂單資料儲存到 localStorage
    function saveOrderData() {
        localStorage.setItem("orderData", JSON.stringify(orderData));
    }

    // 將項目添加到購物車
    function addToCart(item) {
        let existingItem = orderData.items.find(cartItem => cartItem.orderName === item.orderName);
        if (existingItem) {
            existingItem.quantity++;
        } else {
            orderData.items.push({ ...item, quantity: 1 });
        }

        Swal.fire({
            position: "center",
            icon: "success",
            iconColor: "#4CAF50",
            background: "rgb(0,0,0)",
            color: "#4CAF50",
            title: `${item.orderName}已加入購物車`,
            showConfirmButton: false,
            timer: 1000
        });

        renderCart();
    }

    // 點擊添加到購物車按鈕
    $(document).on("click", ".add-to-cart", function() {
        let orderName = $(this).data("name");
        let price = $(this).data("price");
        if (orderName && price) {
            addToCart({ orderName, price });
        }
    });

    // 點擊刪除按鈕
    $(document).on("click", ".remove-item", function () {
        let index = $(this).data("index");
        var itemName = $(this).closest("tr").find("td").eq(0).text().trim();

        Swal.fire({
            title: "確定要刪除嗎?",
            text: "此操作無法恢復！",
            icon: "warning",
            showCancelButton: true,
            background: "rgb(0,0,0)",
            color: "#4CAF50",
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "刪除",
            cancelButtonText: "取消"
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: `${itemName}刪除成功!`,
                    icon: "success",
                    iconColor: "#4CAF50",
                    background: "rgb(0,0,0)",
                    color: "#4CAF50",
                    timer: 1000,
                    showConfirmButton: false
                });

                orderData.items.splice(index, 1);
                renderCart();
            }
        });
    });

    // 修改數量按鈕
    $(document).on("click", ".change-quantity", function () {
        let index = $(this).data("index");
        let action = $(this).data("action");

        if (action === "increase") {
            orderData.items[index].quantity++;
        } else if (action === "decrease" && orderData.items[index].quantity > 1) {
            orderData.items[index].quantity--;
        }

        renderCart();
    });

    // 提交訂單
    $(document).on("click", "#submit-order", function (event) {
        event.preventDefault();

        var tableNumber = $(".form-select").val();
        if (!tableNumber) {
            Swal.fire({
                icon: "error",
                iconColor: "#4CAF50",
                background: "rgb(0,0,0)",
                color: "#4CAF50",
                title: "請選擇桌號！",
                timer: 1500,
                showConfirmButton: false
            });
            return;
        }

        if (orderData.items.length === 0) {
            Swal.fire({
                icon: "error",
                iconColor: "#4CAF50",
                background: "rgb(0,0,0)",
                color: "#4CAF50",
                title: "購物車是空的，無法結帳！",
                timer: 1500,
                showConfirmButton: false
            });
            return;
        }

        orderData.tableNumber = tableNumber;
        orderData.orderTime = new Date().toISOString().replace("T", " ").substring(0, 19);
        orderData.clientId = clientId;

        $.ajax({
            url: "/submitOrder",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(orderData),
            success: function (response) {
                Swal.fire({
                    icon: "success",
                    iconColor: "#4CAF50",
                    background: "rgb(0,0,0)",
                    color: "#4CAF50",
                    title: "訂單已送出！",
                    timer: 1500,
                    showConfirmButton: false
                });

                orderData = {
                    tableNumber: null,
                    total: 0,
                    orderTime: null,
                    items: [],
                    clientId: clientId
                };
                $(".form-select").val(null).prop("selectedIndex", 0);
                renderCart();
            },
            error: function (xhr, status, error) {
                console.error("訂單提交錯誤:", error);
                Swal.fire({
                    icon: "error",
                    iconColor: "#4CAF50",
                    background: "rgb(0,0,0)",
                    color: "#4CAF50",
                    title: `送出訂單失敗: ${xhr.responseText || '請稍後再試'}`,
                    timer: 1500,
                    showConfirmButton: false
                });
            }
        });
    });

    // 初始渲染購物車
    renderCart();
});
//$(document).ready(function () {
//    // 生成或獲取客戶識別碼
//    let clientId = localStorage.getItem('clientId');
//    if (!clientId) {
//        clientId = 'client_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
//        localStorage.setItem('clientId', clientId);
//    }
//
//    // 展開/收縮按鈕邏輯
//    $(".toggle-details").click(function (event) {
//        event.stopPropagation();
//        const parent = $(this).closest(".list-group-item");
//        const details = parent.find(".item-details");
//
//        if (details.is(":visible")) {
//            details.slideUp();
//            $(this).text("展開");
//        } else {
//            $(".item-details").slideUp();
//            $(".toggle-details").text("展開");
//            details.slideDown();
//            $(this).text("收起");
//        }
//    });
//
//    // 點擊圖片切換描述顯示/隱藏
//    $(".meal-thumbnail").click(function () {
//        const description = $(this).closest(".list-item").find(".meal-description");
//        description.slideToggle();
//    });
//
//    // 初始化頁面加載時顯示分頁
//    initializePagination("appetizer");
//
//    // 當視窗大小改變時重新初始化分頁
//    $(window).resize(function () {
//        initializePagination();
//    });
//
//    // 定義訂單數據，加入 clientId
//    let orderData = JSON.parse(localStorage.getItem("orderData")) || {
//        tableNumber: null,
//        total: 0,
//        orderTime: null,
//        items: [],
//        clientId: clientId // 添加 clientId
//    };
//
//    // 監聽選擇框的變化事件
//    $(".form-select").change(function () {
//        orderData.tableNumber = $(this).val();
//        saveOrderData();
//    });
//
//    // 渲染購物車
//    function renderCart() {
//        let cartItems = $("#cart-items");
//        cartItems.empty();
//        let totalPrice = 0;
//        orderData.items.forEach((item, index) => {
//            totalPrice += item.price * item.quantity;
//            cartItems.append(`
//                <tr class="">
//                    <td class="text-center py-2">${item.orderName}</td>
//                    <td class="text-center py-2">${item.price}</td>
//                    <td class="text-center py-2">
//                        <div class="input-group">
//                            <div class="input-group-prepend">
//                                <button class="btn btn-outline-secondary btn-sm change-quantity" data-index="${index}" data-action="decrease">-</button>
//                            </div>
//                            <input type="text" class="form-control text-center quantity-input" value="${item.quantity}" readonly>
//                            <div class="input-group-append">
//                                <button class="btn btn-outline-secondary btn-sm change-quantity" data-index="${index}" data-action="increase">+</button>
//                            </div>
//                        </div>
//                    </td>
//                    <td class="text-center py-2">NT$${item.price * item.quantity}</td>
//                    <td class="text-center py-2"><button type="button" class="btn btn-outline-danger btn-sm remove-item" data-index="${index}">刪除</button></td>
//                </tr>
//            `);
//        });
//        $("#total-amount").text(`總金額: NT$${totalPrice}`);
//        $("#table-number").text(`桌號: ${orderData.tableNumber}`);
//        orderData.totalPrice = totalPrice;
//        saveOrderData();
//    }
//
//    // 將訂單資料儲存到 localStorage
//    function saveOrderData() {
//        localStorage.setItem("orderData", JSON.stringify(orderData));
//    }
//
//    // 將項目添加到購物車
//    function addToCart(item) {
//        let existingItem = orderData.items.find(cartItem => cartItem.orderName === item.orderName);
//        if (existingItem) {
//            existingItem.quantity++;
//        } else {
//            orderData.items.push({ ...item, quantity: 1 });
//        }
//
//        Swal.fire({
//            position: "center",
//            icon: "success",
//            iconColor: "#4CAF50",
//            background: "rgb(0,0,0)",
//            color: "#4CAF50",
//            title: `${item.orderName}已加入購物車`,
//            showConfirmButton: false,
//            timer: 1000
//        });
//
//        renderCart();
//    }
//
//    // 點擊添加到購物車按鈕
//    $("#meal-container").on("click", ".add-to-cart", function () {
//        let orderName = $(this).data("name");
//        let price = $(this).data("price");
//        if (orderName && price) {
//            addToCart({ orderName, price });
//        }
//    });
//
//    // 點擊刪除按鈕
//    $("#cart-items").on("click", ".remove-item", function () {
//        let index = $(this).data("index");
//        var itemName = $(this).closest("tr").find("td").eq(0).text().trim();
//
//        Swal.fire({
//            title: "確定要刪除嗎?",
//            text: "此操作無法恢復！",
//            icon: "warning",
//            showCancelButton: true,
//            background: "rgb(0,0,0)",
//            color: "#4CAF50",
//            confirmButtonColor: "#3085d6",
//            cancelButtonColor: "#d33",
//            confirmButtonText: "刪除",
//            cancelButtonText: "取消"
//        }).then((result) => {
//            if (result.isConfirmed) {
//                Swal.fire({
//                    title: `${itemName}刪除成功!`,
//                    icon: "success",
//                    iconColor: "#4CAF50",
//                    background: "rgb(0,0,0)",
//                    color: "#4CAF50",
//                    timer: 1000,
//                    showConfirmButton: false
//                });
//
//                orderData.items.splice(index, 1);
//                renderCart();
//            }
//        });
//    });
//
//    // 修改數量按鈕
//    $("#cart-items").on("click", ".change-quantity", function () {
//        let index = $(this).data("index");
//        let action = $(this).data("action");
//
//        if (action === "increase") {
//            orderData.items[index].quantity++;
//        } else if (action === "decrease" && orderData.items[index].quantity > 1) {
//            orderData.items[index].quantity--;
//        }
//
//        renderCart();
//    });
//
//    // 提交訂單
//    $("#submit-order").on("click", function (event) {
//        event.preventDefault();
//
//        var tableNumber = $(".form-select").val();
//        if (!tableNumber) {
//            Swal.fire({
//                icon: "error",
//                iconColor: "#4CAF50",
//                background: "rgb(0,0,0)",
//                color: "#4CAF50",
//                title: "請選擇桌號！",
//                timer: 1500,
//                showConfirmButton: false
//            });
//            return;
//        }
//
//        if (orderData.items.length === 0) {
//            Swal.fire({
//                icon: "error",
//                iconColor: "#4CAF50",
//                background: "rgb(0,0,0)",
//                color: "#4CAF50",
//                title: "購物車是空的，無法結帳！",
//                timer: 1500,
//                showConfirmButton: false
//            });
//            return;
//        }
//
//        orderData.tableNumber = tableNumber;
//        orderData.orderTime = new Date().toISOString().replace("T", " ").substring(0, 19);
//        orderData.clientId = clientId; // 添加 clientId 到訂單數據中
//
//		$.ajax({
//		    url: "/submitOrder",  // 改為相對路徑
//		    type: "POST",
//		    contentType: "application/json",
//		    data: JSON.stringify(orderData),
//		    success: function (response) {
//		        Swal.fire({
//		            icon: "success",
//		            iconColor: "#4CAF50",
//		            background: "rgb(0,0,0)",
//		            color: "#4CAF50",
//		            title: "訂單已送出！",
//		            timer: 1500,
//		            showConfirmButton: false
//		        });
//
//		        orderData = {
//		            tableNumber: null,
//		            total: 0,
//		            orderTime: null,
//		            items: [],
//		            clientId: clientId
//		        };
//		        $(".form-select").val(null).prop("selectedIndex", 0);
//		        renderCart();
//		    },
//		    error: function (xhr, status, error) {
//		        console.error("訂單提交錯誤:", error);
//		        Swal.fire({
//		            icon: "error",
//		            iconColor: "#4CAF50",
//		            background: "rgb(0,0,0)",
//		            color: "#4CAF50",
//		            title: `送出訂單失敗: ${xhr.responseText || '請稍後再試'}`,
//		            timer: 1500,
//		            showConfirmButton: false
//		        });
//		    }
//		});
//    // 初始渲染購物車
//    renderCart();
//
//    // 桌號查詢功能
//    window.fetchTableData = function fetchTableData() {
//        const tableNumber = $("#tableNumber").val();
//        if (!tableNumber) {
//            Swal.fire("請選擇桌號", "", "warning");
//            return;
//        }
//
//        const queryParams = new URLSearchParams({
//            tableNumber: tableNumber,
//            clientId: clientId
//        });
//
//        $.get(`/orders/client?${queryParams}`, function (data) {
//            const tableBody = $("#orderTable tbody");
//            tableBody.empty();
//            if (data.length === 0) {
//                Swal.fire("此桌號無訂單資料", "", "info");
//                return;
//            }
//            data.forEach((order) => {
//                const row = `
//                    <tr>
//                        <td>${order.orderId}</td>
//                        <td>${order.tableNumber}</td>
//                        <td>${formatDate(order.orderTime)}</td>
//                        <td>${order.totalPrice}元</td>
//                        <td>
//                            <button class="btn btn-success btn-sm" onclick="viewDetails(${order.orderId})">明細</button>
//                           
//                        </td>
//                    </tr>`;
//                tableBody.append(row);
//            });
//            initializePagination();
//        }).fail(() => {
//            Swal.fire("查詢失敗，請稍後再試", "", "error");
//        });
//    };
//
//    // 查看訂單明細
//    window.viewDetails = function (orderId) {
//        const queryParams = new URLSearchParams({
//            clientId: clientId
//        });
//
//        fetch(`/table/orders/details/${orderId}?${queryParams}`)
//            .then((response) => {
//                if (!response.ok) {
//                    throw new Error("訂單明細未找到");
//                }
//                return response.json();
//            })
//            .then((data) => {
//                if (!data.order || !Array.isArray(data.items)) {
//                    throw new Error("返回數據不完整");
//                }
//
//                $("#detailOrderId").text(data.order.orderId);
//                $("#detailTableNumber").text(data.order.tableNumber);
//
//                const detailsTableBody = $("#orderDetailsTableBody");
//                detailsTableBody.empty();
//
//                data.items.forEach((item) => {
//                    detailsTableBody.append(`
//                        <tr>
//                            <td>${item.orderName}</td>
//                            <td>${item.quantity}</td>
//                            <td>${item.price}元</td>
//                            <td>${item.quantity * item.price}元</td>
//                        </tr>`);
//                });
//
//                $("#detailTotalPrice").text(`${data.order.totalPrice}元`);
//
//                const modal = new bootstrap.Modal($("#orderDetailsModal")[0]);
//                modal.show();
//            })
//            .catch((error) => {
//                console.error("獲取訂單明細失敗：", error);
//                Swal.fire("無法獲取訂單明細", error.message, "error");
//            });
//    };

    // 刪除訂單
//    window.deleteOrder = function (orderId) {
//        Swal.fire({
//            title: "確定刪除訂單？",
//            icon: "warning",
//            iconColor: "#4CAF50",
//            background: "rgb(0,0,0)",
//            color: "#4CAF50",
//            showCancelButton: true,
//            confirmButtonText: "刪除",
//            cancelButtonText: "取消"
//        }).then((result) => {
//            if (result.isConfirmed) {
//                const queryParams = new URLSearchParams({
//                    clientId: clientId
//                });
//
//                fetch(`/table/orders/delete/${orderId}?${queryParams}`, { method: "DELETE" })
//                    .then((response) => {
//                        if (!response.ok) {
//                            throw new Error("刪除失敗");
//                        }
//                        Swal.fire("訂單已刪除", "", "success");
//                        fetchTableData();
//                    })
//                    .catch((error) => {
//                        console.error("刪除失敗：", error);
//                        Swal.fire("刪除失敗，請稍後再試", "", "error");
//                    });
//            }
//        });
//    };
//<button class="btn btn-danger btn-sm" onclick="deleteOrder(${order.orderId})"></button> 
    // 日期格式化
//    function formatDate(dateTime) {
//        const date = new Date(dateTime);
//        return date.toLocaleString("zh-TW", { hour12: false });
//    }
//
//    // 分頁功能
//    function initializePagination() {
//        const rows = $("#orderTable tbody tr");
//        const perPage = 5;
//        rows.hide().slice(0, perPage).show();
//        $("#pagination-container").pagination({
//            items: rows.length,
//            itemsOnPage: perPage,
//            onPageClick: function (pageNumber) {
//                const start = perPage * (pageNumber - 1);
//                const end = start + perPage;
//                rows.hide().slice(start, end).show();
//            },
//            prevText: "<<",
//            nextText: ">>"
//        });
//    }
//});