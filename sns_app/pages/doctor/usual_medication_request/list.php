<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php $id_doctor = $_SESSION["hashed_id"]; ?>
<?php $page_name = "Pedidos de Medicação Habitual - Utentes" ?>

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
                                        <div class="d-flex flex-column flex-md-row align-items-center justify-content-md-between flex-wrap mb-5 gap-4">
                                            <div class="d-flex align-items-center position-relative my-1 mb-2 mb-md-0">
                                                <span class="svg-icon svg-icon-1 position-absolute ms-5">
                                                    <i class="ki-outline ki-magnifier fs-2"></i>
                                                </span>
                                                <input type="text" data-datatable-action="search" class="form-control form-control-solid w-250px ps-15" placeholder="Pesquisar...">
                                            </div>
                                            <div class="d-flex flex-column flex-sm-row align-items-center justify-content-md-end gap-3">
                                                <!-- Botão Adicionar Nova -->
                                                <a href="request" class="btn btn-light-primary d-flex align-items-center lh-1">
                                                    <i class="ki-outline ki-plus fs-2"></i>Pedir
                                                </a>
                                            </div>
                                        </div>
                                        <div class="table-responsive">
                                            <table id="datatable" class="table align-middle gs-0 gy-4">
                                                <thead class="border-bottom border-gray-200 fs-7 fw-bold">
                                                    <tr class="text-start text-muted text-uppercase gs-0">
                                                        <th class="min-w-200px sorting">Nome do Utente</th>
                                                        <th class="min-w-300px sorting">Nome da Medicação</th>
                                                        <th class="min-w-150px sorting">Estado</th>
                                                        <th class="min-w-150px sorting">Data Pedido</th>
                                                        <th class="min-w-100px sorting">Data Resposta</th>
                                                        <th class="min-w-50px">Ações</th>
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
                        url: "http://localhost:3000/api/medications/usual_medication/requests/table",
                        type: "POST",
                        contentType: "application/json",
                        data: () => {
                            return JSON.stringify({
                                'hashed_id_doctor': "<?php echo $id_doctor ?>",
                            });
                        }
                    },
                    columns: [{
                            data: "patient_first_name"
                        },
                        {
                            data: "medication_name"
                        },
                        {
                            data: "status"
                        },
                        {
                            data: "request_date"
                        },
                        {
                            data: "response_date"
                        }, {
                            data: null
                        }
                    ],
                    columnDefs: [{
                            targets: 0,
                            orderable: true,
                            render: (data, type, row) => {
                                return `
                            <div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="text-dark fw-bold text-hover-primary mb-1 fs-6 lh-sm">${row.patient_first_name} ${row.patient_last_name}</span>
                                </div>
                            </div>
                        `
                            },
                        },
                        {
                            targets: 1,
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
                            targets: 2,
                            orderable: true,
                            render: (data, type, row) => {
                                if (row.status == 0) {
                                    return `
                                    <div class="d-inline-flex align-items-center">                                
                                        <div class="d-flex justify-content-center flex-column">
                                            <span class="badge badge-warning px-2 py-2">Em Curso</span>
                                        </div>
                                    </div>
                                    `
                                } else if (row.status == 1) {
                                    return `
                                    <div class="d-inline-flex align-items-center">                                
                                        <div class="d-flex justify-content-center flex-column">
                                            <span class="badge badge-success px-2 py-2">Prescrito</span>
                                        </div>
                                    </div>
                                    `
                                } else if (row.status == 2) {
                                    return `
                                    <div class="d-inline-flex align-items-center">                                
                                        <div class="d-flex justify-content-center flex-column">
                                            <span class="badge badge-danger px-2 py-2">Recusado</span>
                                        </div>
                                    </div>
                                    `
                                }
                            },
                        },
                        {
                            targets: 3,
                            orderable: true,
                            render: (data, type, row) => {
                                var date = new Date(row.request_date);
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
                            targets: 4,
                            orderable: true,
                            render: (data, type, row) => {
                                if (row.response_date != null) {
                                    var date = new Date(row.response_date);
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
                                } else {
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
                        {
                            targets: -1,
                            orderable: false,
                            className: "text-sm-end",
                            render: (data, type, row) => {
                                if (row.status == 0) {
                                    return `
									<div>
                                        <button type="button" data-id="${row.hashed_id_usual_medication_request}" data-info="${row.patient_first_name}" data-name="${row.medication_name}" data-datatable-action="accept-row" class="btn btn-icon btn-bg-light btn-color-success btn-active-light-success rounded w-35px h-35px"><i class="ki-outline ki-capsule fs-2"></i></button>
                                        <button type="button" data-id="${row.hashed_id_usual_medication_request}" data-info="${row.patient_first_name}" data-name="${row.medication_name}" data-datatable-action="cancel-row" class="btn btn-icon btn-bg-light btn-color-danger btn-active-light-danger rounded w-35px h-35px"><i class="ki-outline ki-pill fs-2"></i></button>
                                    </div>
								`;
                                } else {
                                    return ``;
                                }
                            },
                        },
                    ],
                })

                table = dt.$

                dt.on("draw", () => {})
            }

            var handleRows = () => {
                $("#datatable").on("click", "[data-datatable-action='accept-row']", (e) => {
                    e.preventDefault()
                    const button = e.currentTarget
                    const parent = button.closest("tr")
                    const medication = button.getAttribute("data-name")
                    const name = button.getAttribute("data-info")

                    Swal.fire({
                        icon: "success",
                        title: "Prescrever Medicação",
                        text: "Tem a certeza que deseja prescrever a Medicação (" + medication + ") ao Utente (" + name + ") ?",
                        showCancelButton: true,
                        buttonsStyling: false,
                        cancelButtonText: "Não, cancelar",
                        confirmButtonText: "Sim, prescrever",
                        reverseButtons: true,
                        allowOutsideClick: false,
                        didOpen: () => {
                            const confirmButton = Swal.getConfirmButton();
                            confirmButton.blur();
                        },
                        customClass: {
                            confirmButton: "btn fw-bold btn-primary",
                            cancelButton: "btn fw-bold btn-active-light-warning",
                        },
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const id = button.getAttribute("data-id")

                            const data = {
                                hashed_id_usual_medication_request: id,
                                status: 1
                            }

                            const options = {
                                method: "POST",
                                body: JSON.stringify(data),
                                headers: {
                                    "Content-Type": "application/json",
                                },
                            }

                            fetch("http://localhost:3000/api/medications/usual_medication/respond", options)
                                .then((response) => {
                                    response.text().then((json) => {
                                        json = JSON.parse(json)

                                        toastr.options = {
                                            positionClass: "toastr-top-right",
                                            preventDuplicates: true,
                                        }

                                        if (response.status === 201) {
                                            if (json.status === true) {
                                                toastr.success(json.message)
                                                dt.ajax.reload()
                                            }
                                        } else if (response.status === 401) {
                                            toastr.error(json.error)
                                        } else {
                                            toastr.error(json.error)
                                        }
                                    })
                                })
                                .catch((error) => {
                                    console.error(error)
                                })
                        }
                    })
                });
                $("#datatable").on("click", "[data-datatable-action='cancel-row']", (e) => {
                    e.preventDefault()
                    const button = e.currentTarget
                    const parent = button.closest("tr")
                    const medication = button.getAttribute("data-name")
                    const name = button.getAttribute("data-info")

                    Swal.fire({
                        icon: "error",
                        title: "Cancelar Pedido Medicação",
                        text: "Tem a certeza que deseja cancelar o pedido da Medicação (" + medication + ") para o Utente (" + name + ") ?",
                        showCancelButton: true,
                        buttonsStyling: false,
                        cancelButtonText: "Não, voltar",
                        confirmButtonText: "Sim, cancelar",
                        reverseButtons: true,
                        allowOutsideClick: false,
                        didOpen: () => {
                            const confirmButton = Swal.getConfirmButton();
                            confirmButton.blur();
                        },
                        customClass: {
                            confirmButton: "btn fw-bold btn-danger",
                            cancelButton: "btn fw-bold btn-active-light-warning",
                        },
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const id = button.getAttribute("data-id")

                            const data = {
                                hashed_id_usual_medication_request: id,
                                status: 2
                            }

                            const options = {
                                method: "POST",
                                body: JSON.stringify(data),
                                headers: {
                                    "Content-Type": "application/json",
                                },
                            }

                            fetch("http://localhost:3000/api/medications/usual_medication/respond", options)
                                .then((response) => {
                                    response.text().then((json) => {
                                        json = JSON.parse(json)

                                        toastr.options = {
                                            positionClass: "toastr-top-right",
                                            preventDuplicates: true,
                                        }

                                        if (response.status === 201) {
                                            if (json.status === true) {
                                                toastr.success(json.message)
                                                dt.ajax.reload()
                                            }
                                        } else if (response.status === 401) {
                                            toastr.error(json.error)
                                        } else {
                                            toastr.error(json.error)
                                        }
                                    })
                                })
                                .catch((error) => {
                                    console.error(error)
                                })
                        }
                    })
                })
            }


            return {
                init: () => {
                    initDatatable();
                    handleRows();
                },
            }
        })()

        window.addEventListener("DOMContentLoaded", () => {
            datatableServerSide.init()
        })
    </script>

</body>

</html>