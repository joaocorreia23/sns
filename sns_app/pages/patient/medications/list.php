<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php $page_name = "A Minha Medicação Prescrita" ?>
<?php
$api = new Api();
$id_patient = $_SESSION["hashed_id"];
?>
<style>
    .select-info {
        display: none !important;
    }
</style>

<body id="kt_app_body" data-kt-app-header-fixed-mobile="true" data-kt-app-toolbar-enabled="true" class="app-default">
    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
            <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/header.php") ?>
            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
                <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/toolbar.php") ?>
                <div class="app-container container-xxl">
                    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                        <div class="d-flex flex-column flex-column-fluid">
                            <div id="kt_app_content" class="app-content">

                                <!-- Content Here -->
                                <div class="card">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_table_routes">
                                                <!--begin::Table head-->
                                                <thead>
                                                    <!--begin::Table row-->
                                                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                        <th class="text-start">Data Prescrição</th>
                                                        <th colspan="2" class="text-center">Estado</th>
                                                        <th colspan="2" class="text-end">Ações</th>
                                                    </tr>
                                                    <!--end::Table row-->
                                                </thead>
                                                <!--end::Table head-->
                                                <!--begin::Table body-->
                                                <tbody class="text-gray-600 fw-semibold">
                                                </tbody>
                                                <!--end::Table body-->
                                                <!--begin::Table body-->
                                                <tbody class="fw-bold text-gray-600">
                                                    <!--begin::SubTable template-->
                                                    <tr data-kt-docs-datatable-subtable="subtable_template" class="d-none">
                                                        <td class="text-start">
                                                            <div class="d-flex align-items-center gap-3">
                                                                <a href="#" class="symbol symbol-30px bg-secondary bg-opacity-25 rounded">
                                                                    <img src="<?php echo $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['SERVER_NAME'] . '/'; ?>assets/media/icons/duotune/medicine/med002.svg" alt="" data-kt-docs-datatable-subtable="template_image" />
                                                                </a>
                                                                <div class="d-flex flex-column text-muted">
                                                                    <a href="#" class="text-dark text-hover-primary fw-bold" data-kt-docs-datatable-subtable="medication_name">Nome Medicamento</a>
                                                                    <div class="fs-7" data-kt-docs-datatable-subtable="use_description">Descrição Medicamento</div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-end">
                                                            <div class="text-dark fs-7">Qnt. Prescrita</div>
                                                            <div class="text-muted fs-7 fw-bold" data-kt-docs-datatable-subtable="prescribed_amount">1</div>
                                                        </td>
                                                        <td class="text-end">
                                                            <div class="text-dark fs-7">Qnt. Disponível</div>
                                                            <div class="text-muted fs-7 fw-bold" data-kt-docs-datatable-subtable="available_amount">1</div>
                                                        </td>
                                                        <td class="text-end">
                                                            <div class="text-dark fs-7">Cod. Prestação</div>
                                                            <div class="text-muted fs-7 fw-bold" data-kt-docs-datatable-subtable="option_pin">1</div>
                                                        </td>
                                                        <td class="text-end">
                                                            <div class="text-dark fs-7">Cod. Acesso</div>
                                                            <div class="text-muted fs-7 fw-bold" data-kt-docs-datatable-subtable="access_pin">1</div>
                                                        </td>
                                                    </tr>
                                                    <!--end::SubTable template-->

                                                </tbody>
                                                <!--end::Table body-->
                                            </table>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/footer.php") ?>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/foo.php") ?>

    <script>
        // Class definition
        var KTDatatablesServerSide = function() {
            // Shared variables
            var table;
            var dt;
            var template;
            var contents_data = [];

            // Private functions
            var initDatatable = function() {
                // Get subtable template
                const subtable = document.querySelector('[data-kt-docs-datatable-subtable="subtable_template"]');
                template = subtable.cloneNode(true);
                template.classList.remove('d-none');

                // Remove subtable template
                subtable.parentNode.removeChild(subtable);

                dt = $("#kt_table_routes").DataTable({
                    language: {
                        url: "https://cdn.datatables.net/plug-ins/1.13.1/i18n/pt-PT.json",
                    },
                    searchDelay: 500,
                    processing: false,
                    serverSide: false,
                    order: [
                        [1, 'desc']
                    ],
                    stateSave: false, // save datatable state(pagination, sort, etc) in cookie.
                    select: {
                        style: 'multi',
                        selector: 'td:first-child input[type="checkbox"]',
                        className: 'row-selected'
                    },
                    ajax: {
                        url: "http://localhost:3000/api/prescriptions/table",
                        type: "POST",
                        contentType: "application/json",
                        data: () => {
                            return JSON.stringify({
                                'hashed_id_patient': "<?php echo $id_patient ?>"
                            });
                        }
                    },
                    columns: [{
                        data: "prescription_date"
                    }, {
                        data: "prescription_status", //colspan="2"

                    }, {
                        data: null
                    }],
                    columnDefs: [{
                            targets: 0,
                            orderable: false,
                            render: function(data, type, row) {
                                var date = new Date(row.prescription_date);
                                var day = date.getDate();
                                var month = date.getMonth() + 1;
                                var year = date.getFullYear();
                                var formattedDate = (day < 10 ? "0" + day : day) + "/" + (month < 10 ? "0" + month : month) + "/" + year;
                                return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
											<span class="text-dark fw-bold text-hover-primary mb-1 fs-6 lh-sm">${formattedDate}</span>
										</div>
									</div>
								`;
                            }
                        },
                        {
                            targets: 1,
                            className: 'text-center',
                            render: function(data, type, row) {
                                if (row.prescription_status === 1) {
                                    return `<span class="badge badge-success">Prescrita</span>`;
                                } else if (row.prescription_status === 0) {
                                    return `<span class="badge badge-danger">Indisponível</span>`;
                                }
                            }
                        },
                        {
                            targets: -1,
                            data: null,
                            orderable: false,
                            className: 'text-end',
                            render: function(data, type, row) {
                                contents = row.medication_prescription_list;
                                contents_data[row.hashed_id_prescription] = contents;
                                return `
                                
                                    <button type="button" class="btn btn-sm btn-icon btn-light btn-active-light-primary toggle fw-bold fs-7 py-4" data-kt-docs-datatable-subtable="expand_row" data-hashed_id="${row.hashed_id_prescription}">
                                    
                                        <span class="toggle-off">
                                        <i class="ki-outline ki-eye fs-2"></i>
                                        </span>

                                        <span class="toggle-on fs-3">
                                        <i class="ki-outline ki-eye-slash fs-2"></i>
                                        </span>
                                    
                                    </button>
                                
                        `;
                            },
                        },
                    ],
                    createdRow: function(row, data, index) {
                        $('td', row).eq(1).attr('colspan', 2);
                        $('td', row).eq(2).attr('colspan', 2);
                    },
                });

                table = dt.$;
                console.log('table', table);
                if(dt.rows.length < 1){
                    setInterval(function() {
                        $('.dataTables_empty').attr('colspan', 4);    
                    }, 50);
                                    
                }

                // Re-init functions on every table re-draw -- more info: https://datatables.net/reference/event/draw
                dt.on('draw', function() {
                    resetSubtable();
                    handleActionButton();
                    KTMenu.createInstances();
                });
            }

            // Handle action button
            const handleActionButton = () => {
                const buttons = document.querySelectorAll('[data-kt-docs-datatable-subtable="expand_row"]');
                console.log(buttons);

                buttons.forEach((button, index) => {
                    button.addEventListener('click', e => {
                        e.stopImmediatePropagation();
                        e.preventDefault();

                        const hashed_id = button.getAttribute('data-hashed_id');

                        const row = button.closest('tr');
                        const rowClasses = ['isOpen', 'border-bottom-0'];

                        // Get total number of items to generate --- for demo purpose only, remove this code snippet in your project
                        const demoData = [];
                        for (var j = 0; j < contents_data[hashed_id].length; j++) {
                            demoData.push(contents_data[hashed_id][j]);
                        }
                        // End of generating demo data

                        // Handle subtable expanded state
                        if (row.classList.contains('isOpen')) {
                            // Remove all subtables from current order row
                            while (row.nextSibling && row.nextSibling.getAttribute('data-kt-docs-datatable-subtable') === 'subtable_template') {
                                row.nextSibling.parentNode.removeChild(row.nextSibling);
                            }
                            row.classList.remove(...rowClasses);
                            button.classList.remove('active');
                        } else {
                            populateTemplate(demoData, row);
                            row.classList.add(...rowClasses);
                            button.classList.add('active');
                        }
                    });
                });
            }

            // Populate template with content/data -- content/data can be replaced with relevant data from database or API
            const populateTemplate = (data, target) => {
                console.log('data', data);
                data.forEach((d, index) => {
                    // Clone template node
                    console.log('d', d);
                    const newTemplate = template.cloneNode(true);

                    // Select data elements
                    const medication_name = newTemplate.querySelector('[data-kt-docs-datatable-subtable="medication_name"]');
                    const use_description = newTemplate.querySelector('[data-kt-docs-datatable-subtable="use_description"]');
                    const prescribed_amount = newTemplate.querySelector('[data-kt-docs-datatable-subtable="prescribed_amount"]');
                    const available_amount = newTemplate.querySelector('[data-kt-docs-datatable-subtable="available_amount"]');
                    const option_pin = newTemplate.querySelector('[data-kt-docs-datatable-subtable="option_pin"]');
                    const access_pin = newTemplate.querySelector('[data-kt-docs-datatable-subtable="access_pin"]');

                    // Populate elements with data
                    medication_name.textContent = d.medication_name;
                    use_description.textContent = d.use_description;
                    prescribed_amount.textContent = d.prescribed_amount;
                    available_amount.textContent = d.available_amount;
                    option_pin.textContent = d.option_pin;
                    access_pin.textContent = d.access_pin;

                    // New template border controller
                    // When only 1 row is available
                    if (data.length === 1) {
                        let borderClasses = ['rounded', 'rounded-end-0'];
                        newTemplate.querySelectorAll('td')[0].classList.add(...borderClasses);
                        borderClasses = ['rounded', 'rounded-start-0'];
                        newTemplate.querySelectorAll('td')[4].classList.add(...borderClasses);

                        // Remove bottom border
                        newTemplate.classList.add('border-bottom-0');
                    } else {
                        // When multiple rows detected
                        if (index === (data.length - 1)) { // first row
                            let borderClasses = ['rounded-start', 'rounded-bottom-0'];
                            newTemplate.querySelectorAll('td')[0].classList.add(...borderClasses);
                            borderClasses = ['rounded-end', 'rounded-bottom-0'];
                            newTemplate.querySelectorAll('td')[4].classList.add(...borderClasses);
                        }
                        if (index === 0) { // last row
                            let borderClasses = ['rounded-start', 'rounded-top-0'];
                            newTemplate.querySelectorAll('td')[0].classList.add(...borderClasses);
                            borderClasses = ['rounded-end', 'rounded-top-0'];
                            newTemplate.querySelectorAll('td')[4].classList.add(...borderClasses);

                            // Remove bottom border on last row
                            newTemplate.classList.add('border-bottom-0');
                        }
                    }

                    // Insert new template into table
                    const tbody = document.getElementById('kt_table_routes').querySelector('tbody');
                    tbody.insertBefore(newTemplate, target.nextSibling);
                });
            }

            // Reset subtable
            const resetSubtable = () => {
                const subtables = document.querySelectorAll('[data-kt-docs-datatable-subtable="subtable_template"]');
                subtables.forEach(st => {
                    st.parentNode.removeChild(st);
                });

                const rows = document.getElementById('kt_table_routes').querySelectorAll('tbody tr');
                rows.forEach(r => {
                    r.classList.remove('isOpen');
                    if (r.querySelector('[data-kt-docs-datatable-subtable="expand_row"]')) {
                        r.querySelector('[data-kt-docs-datatable-subtable="expand_row"]').classList.remove('active');
                    }
                });
            }


            // Public methods
            return {
                init: function() {
                    initDatatable();
                }
            }
        }();

        // On document ready
        window.addEventListener('DOMContentLoaded', function() {
            KTDatatablesServerSide.init();
        });
    </script>

</body>

</html>