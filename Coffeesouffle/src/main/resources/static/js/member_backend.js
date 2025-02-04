$(document).ready(function () {
    // 初始化工具提示
    initializeTooltips();
    // 初始化分頁
    initializePagination();
    // 初始化表單驗證
    initFormValidation();

    // 密碼顯示/隱藏切換
    $('.passwordToggle').on('click', function () {
        let passwordField = $(this).closest('.password-eye').find('input');
        let iconEye = $(this).find('.fa-eye');
        let iconEyeSlash = $(this).find('.fa-eye-slash');

        if (passwordField.attr('type') === 'password') {
            passwordField.attr('type', 'text');
        } else {
            passwordField.attr('type', 'password');
        }

        iconEye.toggleClass('d-none');
        iconEyeSlash.toggleClass('d-none');
    });

    // 初始化排序
    initializeSorting();

    // 密碼驗證規則
    function validatePattern(password) {
        var pattern = /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/;
        return pattern.test(password);
    }

    // 密碼驗證
    $('#updatePassword, #updatePassword2').on('input', function () {
        var password1 = $('#updatePassword').val();
        var password2 = $('#updatePassword2').val();

        if (!validatePattern(password1)) {
            $('#updatePassword')[0].setCustomValidity('密碼必須至少包含一個字母、一個數字，且至少6個字符');
        } else {
            $('#updatePassword')[0].setCustomValidity('');
        }

        if (password1 !== password2) {
            $('#updatePassword2')[0].setCustomValidity('密碼不吻合');
        } else {
            $('#updatePassword2')[0].setCustomValidity('');
        }
    });
});

// 初始化工具提示
function initializeTooltips() {
    $('[data-bs-toggle="tooltip"]').tooltip();
    $('.ellipsis').each(function () {
        $(this).attr('title', $(this).text());
    });
}

// 初始化表單驗證
function initFormValidation() {
    
	// 新增員工表單提交處理
	$('#createEmployee').on('submit', function (e) {
	    e.preventDefault();
	    console.log('Form submitted');
	    
	    const formData = new FormData(this);
	    
	    // 輸出表單數據進行調試
	    for (let pair of formData.entries()) {
	        console.log(pair[0] + ': ' + pair[1]);
	    }

	    $.ajax({
	        url: '/member_backend',
	        type: 'POST',
	        data: formData,
	        processData: false,
	        contentType: false,
	        success: function (response) {
	            Swal.fire({
	                title: '新增成功！',
	                icon: 'success',
	                iconColor: '#4CAF50',
	                background: 'rgb(0,0,0)',
	                color: '#4CAF50',
	                showConfirmButton: false,
	                timer: 1500
	            }).then(() => {
	                location.reload();
	            });
	        },
	        error: function (xhr, status, error) {
	            console.error('Error:', xhr.responseText);
	            Swal.fire({
	                title: '新增失敗',
	                text: xhr.responseText || '請檢查輸入資料是否正確',
	                icon: 'error',
	                iconColor: '#4CAF50',
	                background: 'rgb(0,0,0)',
	                color: '#4CAF50'
	            });
	        }
	    });
	});
    // 修改員工表單
    $('#updateEmployeeForm').on('submit', function (e) {
        e.preventDefault();
        
        if (!this.checkValidity()) {
            e.stopPropagation();
            this.classList.add('was-validated');
            return;
        }

        const memberId = $('#updateMemberId').val();
        const formData = new FormData(this);
        formData.append('_method', 'PUT');
        formData.append('isMember', '1');

        $.ajax({
            url: `/member_backend/${memberId}`,
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function () {
                Swal.fire({
                    title: '修改成功！',
                    icon: 'success',
                    iconColor: '#4CAF50',
                    background: 'rgb(0,0,0)',
                    color: '#4CAF50',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    location.reload();
                });
            },
            error: function (xhr) {
                Swal.fire({
                    title: '修改失敗',
                    text: xhr.responseText || '請檢查輸入資料是否正確',
                    icon: 'error',
                    iconColor: '#4CAF50',
                    background: 'rgb(0,0,0)',
                    color: '#4CAF50'
                });
            }
        });
    });
}

// 編輯員工函數
window.editMember = function (memberId) {
    console.log('Editing member:', memberId);
    
    // 修改選擇器，確保準確找到對應的行數據
    const row = $(`#memberTable tbody tr`).filter(function() {
        return $(this).find('td:first').text() == memberId;
    });
    
    if (row.length > 0) {
        $('#updateMemberId').val(memberId);
        // 使用 trim() 去除可能的空白
        $('#updateAccount').val(row.find('td:eq(1)').text().trim());
        $('#updateName').val(row.find('td:eq(2)').text().trim());
        $(`input[name="gender"][value="${row.find('td:eq(3)').text().trim()}"]`).prop('checked', true);
        $('#updateBirthday').val(row.find('td:eq(4)').text().trim());
        $('#updateEmail').val(row.find('td:eq(5)').text().trim());
        $('#updatePhone').val(row.find('td:eq(6)').text().trim());

        $('#updateEmployeeModal').modal('show');
    } else {
        console.error('Row not found for memberId:', memberId);
    }
};

// 刪除員工函數
window.deleteMember = function (memberId) {
    console.log('Deleting member:', memberId);
    Swal.fire({
        title: '確定要刪除嗎？',
        text: "此操作無法恢復！",
        icon: 'warning',
        iconColor: '#4CAF50',
        background: 'rgb(0,0,0)',
        color: '#4CAF50',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '確定刪除',
        cancelButtonText: '取消'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: `/member_backend/${memberId}`,
                type: 'DELETE',
                success: function () {
                    Swal.fire({
                        title: '刪除成功！',
                        icon: 'success',
                        iconColor: '#4CAF50',
                        background: 'rgb(0,0,0)',
                        color: '#4CAF50',
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {
                        location.reload();
                    });
                },
                error: function (xhr) {
                    Swal.fire({
                        title: '刪除失敗',
                        text: xhr.responseText || '請稍後再試',
                        icon: 'error',
                        iconColor: '#4CAF50',
                        background: 'rgb(0,0,0)',
                        color: '#4CAF50'
                    });
                }
            });
        }
    });
};

// 初始化分頁功能
function initializePagination() {
    const itemsPerPage = 10; // 固定每頁顯示10筆
    const $rows = $("#memberTable tbody tr");
    const numItems = $rows.length;

    $rows.hide();
    $rows.slice(0, itemsPerPage).show();

    $('#pagination-container').pagination({
        items: numItems,
        itemsOnPage: itemsPerPage,
        prevText: "上一頁",
        nextText: "下一頁",
        cssStyle: 'light-theme', // 使用預設主題
        onPageClick: function(pageNumber) {
            const showFrom = itemsPerPage * (pageNumber - 1);
            const showTo = showFrom + itemsPerPage;
            $rows.hide()
                .slice(showFrom, showTo)
                .show();
        }
    });

    // 添加頁面資訊
    const totalPages = Math.ceil(numItems / itemsPerPage);
    $('#pagination-container').append(
        `<div class="pagination-info mt-2 text-center">
            共 ${numItems} 筆資料，${totalPages} 頁
        </div>`
    );
}

// 獲取每頁顯示數量
//function getPerPage() {
//    if (window.innerWidth < 767) return 6;
//    if (window.innerWidth < 992) return 8;
//    return 10;
//}
//
//// 監聽視窗大小變化
//$(window).resize(function () {
//    initializePagination();
//});

// 初始化排序功能
function initializeSorting() {
    let isAscending = true;
    
    $('th img').click(function () {
        const columnIndex = $(this).closest('th').index();
        const $tbody = $('#memberTable tbody');
        const rows = $tbody.find('tr').get();
        
        rows.sort((a, b) => {
            const aValue = $(a).find('td').eq(columnIndex).text().toLowerCase();
            const bValue = $(b).find('td').eq(columnIndex).text().toLowerCase();
            return isAscending ? 
                aValue.localeCompare(bValue) : 
                bValue.localeCompare(aValue);
        });
        
        isAscending = !isAscending;
        $(this).css('transform', `rotate(${isAscending ? 0 : 180}deg)`);
        $tbody.empty().append(rows);
    });
}