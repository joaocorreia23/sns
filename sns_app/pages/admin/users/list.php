<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php $page_name = "Listagem de Utilizadores" ?>

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
												<button type="button" class="btn btn-icon btn-active-light-primary lh-1" data-datatable-action="sync" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" title="Sincronizar tabela">
													<i class="ki-outline ki-arrows-circle fs-2"></i>
												</button>

												<a href="add" class="btn btn-light-primary d-flex align-items-center lh-1">
													<i class="ki-outline ki-plus fs-2"></i>Adicionar
												</a>
											</div>
										</div>

										<div class="table-responsive">
											<table id="datatable" class="table align-middle gs-0 gy-4">
												<thead>
													<tr class="fw-bold text-muted bg-light">
														<th class="ps-4 fs-6 min-w-300px rounded-start" data-priority="1">Nome</th>
														<th class="ps-4 fs-6 min-w-100px rounded-start" data-priority="4">Email</th>
														<th class="ps-4 fs-6 min-w-100px rounded-start" data-priority="4">Telefone</th>
														<th class="ps-4 fs-6 min-w-100px rounded-start" data-priority="4">NIF</th>
														<th class="ps-4 fs-6 min-w-100px rounded-start" data-priority="4">Data de Criação</th>
														<th class="pe-4 fs-6 min-w-200px text-sm-end rounded-end" data-priority="5">Ações</th>
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
					lengthMenu: [10, 25, 50, 75, 100],
					stateSave: false,
					ajax: {
						url: "http://localhost:3000/api/users/table",
						type: "GET",
					},
					columns: [{
							data: "first_name"
						},
						{
							data: "email"
						},
						{
							data: "phone_number"
						},
						{
							data: "tax_number"
						},
						{
							data: "created_at"
						},
						{
							data: null
						}
					],
					columnDefs: [{
							targets: 0,
							orderable: true,
							render: (data, type, row) => {
								const name = row.first_name !== null && row.last_name !== null ? row.first_name + " " + row.last_name : 'Perfil sem nome';
								return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
											<span class="text-dark fw-bold text-hover-primary mb-1 fs-6 lh-sm">${name}</span>
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
										<span class="mb-1 fs-6 lh-sm">${row.email}</span>
										</div>
									</div>
								`;

							},
						},
						{
							targets: 2,
							orderable: true,
							render: (data, type, row) => {

								return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
										<span class="mb-1 fs-6 lh-sm">${row.phone_number != null ? row.phone_number : 'N/A'}</span>
										</div>
									</div>
								`;

							},
						},
						{
							targets: 3,
							orderable: true,
							render: (data, type, row) => {

								return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
										<span class="mb-1 fs-6 lh-sm">${row.tax_number != null ? row.tax_number : 'N/A'}</span>
										</div>
									</div>
								`;

							},
						},
						{
							targets: 4,
							orderable: true,
							render: (data, type, row) => {
								var date = new Date(row.created_at);
								var day = date.getDate();
								var month = date.getMonth() + 1;
								var year = date.getFullYear();
								var formattedDate = (day < 10 ? "0" + day : day) + "/" + (month < 10 ? "0" + month : month) + "/" + year + " " + (date.getHours() < 10 ? "0" + date.getHours() : date.getHours()) + ":" + (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
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
							targets: -1,
							orderable: false,
							className: "text-sm-end",
							render: (data, type, row) => {
								return `
									<div>
										<a href="edit?id=${row.hashed_id}" class="btn btn-icon btn-bg-light btn-color-primary btn-active-light-primary rounded w-35px h-35px me-1"><i class="ki-outline ki-notepad-edit fs-2"></i></a>
										<button type="button" data-id="${row.hashed_id}" data-name="${row.first_name}" data-datatable-action="delete-row" class="btn btn-icon btn-bg-light btn-color-danger btn-active-light-danger rounded w-35px h-35px"><i class="ki-outline ki-trash fs-2"></i></button>
									</div>
								`;
							},
						},
					],
				})

				table = dt.$

				dt.on("draw", () => {})
			}

			var handleSyncDatatable = () => {
				const syncButton = document.querySelector(`[data-datatable-action="sync"]`)
				if (!syncButton) {
					toastr.error("Não foi possível encontrar o botão de sincronização.")
					return
				}

				syncButton.addEventListener("click", (e) => {
					e.preventDefault()
					dt.ajax.reload()
				})
			}

			var handleSearchDatatable = () => {
				const filterSearch = document.querySelector(`[data-datatable-action="search"]`)
				filterSearch.addEventListener("keyup", (e) => dt.search(e.target.value).draw())
			}

			var handleDeleteRows = () => {
				const deleteButtons = document.querySelectorAll(`[data-datatable-action="delete-row"]`)

				$("#datatable").on("click", "[data-datatable-action='delete-row']", (e) => {
					e.preventDefault()
					const button = e.currentTarget
					const parent = button.closest("tr")
					const name = button.getAttribute("data-name")

					Swal.fire({
						icon: "warning",
						title: "Desativar Vacina",
						text: "Tem a certeza que deseja desativar a Vacina (" + name + ") ?",
						showCancelButton: true,
						buttonsStyling: false,
						cancelButtonText: "Não, cancelar",
						confirmButtonText: "Sim, desativar",
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
								hashed_id: id,
							}

							const options = {
								method: "POST",
								body: JSON.stringify(data),
								headers: {
									"Content-Type": "application/json",
								},
							}

							fetch("http://localhost:3000/api/vaccines/deactivate", options)
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
					initDatatable()
					handleSyncDatatable()
					handleSearchDatatable()
					handleDeleteRows()
				},
			}
		})()

		window.addEventListener("DOMContentLoaded", () => {
			datatableServerSide.init()
		})
	</script>
</body>

</html>