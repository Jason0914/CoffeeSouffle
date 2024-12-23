$(document).ready(function () {
    // 生成或獲取客戶識別碼
    let clientId = localStorage.getItem('clientId');
    if (!clientId) {
        clientId = 'client_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        localStorage.setItem('clientId', clientId);
    }

    // 桌號查詢功能
    window.fetchTableData = function fetchTableData() {
        const tableNumber = $("#tableNumber").val();
        if (!tableNumber) {
            Swal.fire("請選擇桌號", "", "warning");
            return;
        }

        const queryParams = new URLSearchParams({
            tableNumber: tableNumber,
            clientId: clientId
        });

        $.get(`/orders/client?${queryParams}`, function (data) {
            const tableBody = $("#orderTable tbody");
            tableBody.empty();
            if (data.length === 0) {
                Swal.fire("此桌號無訂單資料", "", "info");
                return;
            }
            data.forEach((order) => {
                const row = `
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.tableNumber}</td>
                        <td>${formatDate(order.orderTime)}</td>
                        <td>${order.totalPrice}元</td>
                        <td>
                            <button class="btn btn-success btn-sm" onclick="viewDetails(${order.orderId})">明細</button>
                        </td>
                    </tr>`;
                tableBody.append(row);
            });
            initializePagination();
        }).fail(() => {
            Swal.fire("查詢失敗，請稍後再試", "", "error");
        });
    };

    // 查看訂單明細
    window.viewDetails = function (orderId) {
        const queryParams = new URLSearchParams({
            clientId: clientId
        });

        fetch(`/table/orders/details/${orderId}?${queryParams}`)
            .then((response) => {
                if (!response.ok) {
                    throw new Error("訂單明細未找到");
                }
                return response.json();
            })
            .then((data) => {
                if (!data.order || !Array.isArray(data.items)) {
                    throw new Error("返回數據不完整");
                }

                $("#detailOrderId").text(data.order.orderId);
                $("#detailTableNumber").text(data.order.tableNumber);

                const detailsTableBody = $("#orderDetailsTableBody");
                detailsTableBody.empty();

                data.items.forEach((item) => {
                    detailsTableBody.append(`
                        <tr>
                            <td>${item.orderName}</td>
                            <td>${item.quantity}</td>
                            <td>${item.price}元</td>
                            <td>${item.quantity * item.price}元</td>
                        </tr>`);
                });

                $("#detailTotalPrice").text(`${data.order.totalPrice}元`);

                const modal = new bootstrap.Modal($("#orderDetailsModal")[0]);
                modal.show();
            })
            .catch((error) => {
                console.error("獲取訂單明細失敗：", error);
                Swal.fire("無法獲取訂單明細", error.message, "error");
            });
    };

    // 日期格式化
    function formatDate(dateTime) {
        const date = new Date(dateTime);
        return date.toLocaleString("zh-TW", { hour12: false });
    }

    // 分頁功能
    function initializePagination() {
        const rows = $("#orderTable tbody tr");
        const perPage = 5;
        rows.hide().slice(0, perPage).show();
        $("#pagination-container").pagination({
            items: rows.length,
            itemsOnPage: perPage,
            onPageClick: function (pageNumber) {
                const start = perPage * (pageNumber - 1);
                const end = start + perPage;
                rows.hide().slice(start, end).show();
            },
            prevText: "<<",
            nextText: ">>"
        });
    }
});