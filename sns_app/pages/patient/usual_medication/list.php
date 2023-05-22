<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php $id_patient = $_SESSION["hashed_id"]; ?>
<?php $page_name = "A Minha Medicação Habitual" ?>

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
                                            <table id="datatable" class="table align-middle gs-0 gy-4">
                                                <thead class="border-bottom border-gray-200 fs-7 fw-bold">
                                                    <tr class="text-start text-muted text-uppercase gs-0">
                                                        <th class="min-w-300px sorting">Nome da Medicação</th>
                                                        <th class="min-w-150px sorting">Estado</th>
                                                        <th class="min-w-150px sorting">Desde</th>
                                                        <th class="min-w-100px sorting">Até</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
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
        var datatableServerSide = (function() {
            var table
            var dt

            var initDatatable = () => {
                dt = $("#datatable").DataTable({
                    language: {
                        url: "https://cdn.datatables.net/plug-ins/1.13.1/i18n/pt-PT.json",
                    },
                    searchDelay: 1000,
                    processing: true,
                    serverSide: false,
                    responsive: true,
                    order: [
                        [0, "asc"]
                    ],
                    lengthMenu: [5, 10, 25, 50, 75, 100],
                    stateSave: false,
                    ajax: {
                        url: "http://localhost:3000/api/medications/usual_medication/table",
                        type: "POST",
                        contentType: "application/json",
                        data: () => {
                            return JSON.stringify({
                                'hashed_id_patient': "<?php echo $id_patient ?>"
                            });
                        }
                    },
                    columns: [{
                            data: "medication_name"
                        },
                        {
                            data: "usual_medication_status"
                        },
                        {
                            data: "usual_medication_created_at"
                        },
                        {
                            data: "usual_medication_updated_at"
                        }
                    ],
                    columnDefs: [{
                            targets: 0,
                            orderable: true,
                            render: (data, type, row) => {
                                return `
                            <div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="text-dark fw-bold text-hover-primary mb-1 fs-6 lh-sm">${row.medication_name}</span>
                                </div>
                            </div>
                        `
                            },
                        },
                        {
                            targets: 1,
                            orderable: true,
                            render: (data, type, row) => {
                                if(row.usual_medication_status == 0){
                                    return `
                                    <div class="d-inline-flex align-items-center">                                
                                        <div class="d-flex justify-content-center flex-column">
                                            <span class="badge badge-warning px-2 py-2">Finalizada</span>
                                        </div>
                                    </div>
                                    `
                                }else if(row.usual_medication_status == 1){
                                    return `
                                    <div class="d-inline-flex align-items-center">                                
                                        <div class="d-flex justify-content-center flex-column">
                                            <span class="badge badge-success px-2 py-2">Em Curso</span>
                                        </div>
                                    </div>
                                    `
                                }
                            },
                        },
                        {
                            targets: 2,
                            orderable: true,
                            render: (data, type, row) => {
                                var date = new Date(row.usual_medication_created_at);
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
                            },
                        },
                        {
                            targets: 3,
                            orderable: true,
                            render: (data, type, row) => {
                                if(row.usual_medication_updated_at !== null){
                                    var date = new Date(row.usual_medication_updated_at);
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
                                }else{
                                    return `
                                        <div class="d-inline-flex align-items-center">                                
                                            <div class="d-flex justify-content-center flex-column">
                                                <span class="text-dark fw-bold text-hover-primary mb-1 fs-6 lh-sm">-</span>
                                            </div>
                                        </div>
                                    `;
                                }
                            },
                        },

                    ],
                })

                table = dt.$

                dt.on("draw", () => {})
            }


            return {
                init: () => {
                    initDatatable()
                },
            }
        })()

        window.addEventListener("DOMContentLoaded", () => {
            datatableServerSide.init()
        })
    </script>

</body>

</html>