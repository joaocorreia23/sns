<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$id_health_unit = $_GET["id"];
$api = new Api();
$health_unit_info = $api->fetch("health_unit/", null, $id_health_unit);
$health_unit_data = $health_unit_info["response"];

$health_unit_doctors = $api->fetch("health_unit/doctors", null, $id_health_unit);
$health_unit_doctors_data = $health_unit_doctors["response"];

$health_unit_patients = $api->fetch("health_unit/patients", null, $id_health_unit);
$health_unit_patients_data = $health_unit_patients["response"];

$doctors = $api->fetch("users/role", null, "Doctor");
$doctors_list = $doctors["response"]["data"];

$patients = $api->fetch("users/role", null, "Patient");
$patients_list = $patients["response"]["data"];

$page_name = "Unidade de Saúde -" . ' ' . $health_unit_data["name"];
?>

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
								<div class="d-flex flex-column flex-xl-row">
									<!--begin::Sidebar-->
									<div class="flex-column flex-lg-row-auto w-100 w-xl-350px mb-10">
										<!--begin::Card-->
										<div class="card mb-5 mb-xl-8">
											<!--begin::Card body-->
											<div class="card-body pt-15">
												<!--begin::Summary-->
												<div class="d-flex flex-center flex-column mb-5">
													<!--begin::Name-->
													<a href="#" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-1"><?php echo $health_unit_data["name"] ?></a>
													<!--end::Name-->
													<!--begin::Position-->
													<div class="fs-6 fw-semibold text-muted mb-1"><?php echo $health_unit_data["email"] ?></div>
													<div class="fs-6 fw-semibold text-muted mb-4"><?php echo $health_unit_data["phone_number"] ?></div>
													<!--end::Position-->
													<?php if ($health_unit_data["type"] === "Hospital Publico") {
														echo '<span class="badge badge-success px-2 py-2">Hospital Publico</span>';
													} else if ($health_unit_data["type"] === "Hospital Privado") {
														echo '<span class="badge badge-danger px-2 py-2">Hospital Privado</span>';
													} else if ($health_unit_data["type"] === "Clinica Publica") {
														echo '<span class="badge badge-warning px-2 py-2">Clinica Publica</span>';
													} else if ($health_unit_data["type"] === "Clinica Privada") {
														echo '<span class="badge badge-info px-2 py-2">Clinica Privada</span>';
													} else if ($health_unit_data["type"] === "Centro de Saúde") {
														echo '<span class="badge badge-dark px-2 py-2">Centro de Saúde</span>';
													} else {
														echo '<span class="badge badge-secondary px-2 py-2">Outro</span>';
													} ?>
												</div>
												<!--end::Summary-->
												<!--begin::Details toggle-->
												<div class="d-flex flex-stack fs-4 py-3">
													<div class="fw-bold rotate collapsible active" data-bs-toggle="collapse" href="#kt_customer_view_details" role="button" aria-expanded="true" aria-controls="kt_customer_view_details">Detalhes
														<span class="ms-2 rotate-180">
															<i class="ki-outline ki-down fs-3"></i>
														</span>
													</div>
													<span data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-original-title="Edit customer details" data-kt-initialized="1">
														<a href="" class="btn btn-sm btn-light-primary">Editar</a>
													</span>
												</div>
												<!--end::Details toggle-->
												<div class="separator separator-dashed my-3"></div>
												<!--begin::Details content-->
												<div id="kt_customer_view_details" class="collapse show">
													<div class="py-5 fs-6">

														<div class="fw-bold mt-5">NIF</div>
														<div class="text-gray-600"><?php echo $health_unit_data["tax_number"] ?></div>

														<div class="fw-bold mt-5">País</div>
														<div class="text-gray-600"><?php echo $health_unit_data["country_name"] ?></div>

														<div class="fw-bold mt-5">Distrito</div>
														<div class="text-gray-600"><?php echo $health_unit_data["district_name"] ?></div>

														<div class="fw-bold mt-5">Concelho</div>
														<div class="text-gray-600"><?php echo $health_unit_data["county_name"] ?></div>

														<div class="fw-bold mt-5">Morada</div>
														<div class="text-gray-600"><?php echo $health_unit_data["zip_code"] ?></div>
														<div class="text-gray-600"><?php echo $health_unit_data["address"] ?></div>
														<div class="text-gray-600"><span class="fw-bold">Porta:</span> <?php echo $health_unit_data["door_number"] ?> <span class="fw-bold">Andar:</span> <?php echo $health_unit_data["floor"] ?></div>

														<div class="fw-bold mt-5">Criada em:</div>
														<div class="text-gray-600"><?php echo (new DateTime($health_unit_data["created_at"]))->format("d/m/Y - H:i"); ?></div>
													</div>
												</div>
												<!--end::Details content-->
											</div>
											<!--end::Card body-->
										</div>
										<!--end::Card-->
									</div>
									<!--end::Sidebar-->
									<!--begin::Content-->
									<div class="flex-lg-row-fluid ms-lg-15">
										<!--begin:::Tabs-->
										<ul class="nav nav-custom nav-tabs nav-line-tabs nav-line-tabs-2x border-0 fs-4 fw-semibold mb-8" role="tablist">
											<li class="nav-item" role="presentation">
												<a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" href="#doctors" aria-selected="true" role="tab">Médicos</a>
											</li>
											<li class="nav-item" role="presentation">
												<a class="nav-link text-active-primary pb-4" data-bs-toggle="tab" href="#patients" aria-selected="false" role="tab" tabindex="-1">Utentes</a>
											</li>
											<li class="nav-item" role="presentation">
												<a class="nav-link text-active-primary pb-4" data-kt-countup-tabs="true" data-bs-toggle="tab" href="#appointments" data-kt-initialized="1" aria-selected="false" role="tab" tabindex="-1">Consultas</a>
											</li>
											<li class="nav-item ms-auto">
												<a class="btn btn-primary ps-7" data-kt-menu-trigger="click" data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">Associar
													<i class="ki-outline ki-down fs-2 me-0"></i></a>
												<div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg-light-primary fw-semibold py-4 w-250px fs-6" data-kt-menu="true" style="">
													<div class="menu-item px-5">
														<div class="menu-content text-muted pb-2 px-5 fs-7 text-uppercase">Associação de:</div>
													</div>
													<div class="menu-item px-5">
														<a data-bs-toggle="modal" data-bs-target="#modal-associate-doctor" class="menu-link px-5">Médico</a>
													</div>
													<div class="menu-item px-5">
														<a data-bs-toggle="modal" data-bs-target="#modal-associate-patient" class="menu-link px-5">Utente</a>
													</div>
												</div>
											</li>
										</ul>
										<!--end:::Tabs-->
										<!--begin:::Tab content-->
										<div class="tab-content" id="myTabContent">
											<!-- Médicos Associado -->
											<div class="tab-pane fade active show" id="doctors" role="tabpanel">
												<div class="card pt-4 mb-6 mb-xl-9">
													<div class="card-header border-0">
														<div class="card-title">
															<h2>Médicos Associados</h2>
														</div>
													</div>
													<div class="card-body py-0">
														<div class="table-responsive">
															<table class="table align-middle table-row-dashed fw-semibold text-gray-600 fs-6 gy-5" id="kt_table_customers_logs">
																<tbody>
																	<tr class="text-start text-muted text-uppercase gs-0">
																		<th class="min-w-150px sorting">Nome</th>
																		<th class="min-w-150px sorting">Email</th>
																		<th class="min-w-80px sorting">Telemóvel</th>
																		<th class="min-w-80px sorting"></th>
																	</tr>
																	<?php foreach ($health_unit_doctors_data as $key => $value) { ?>
																		<tr>
																			<td><?php echo isset($value["doctor_name"]) ? $value["doctor_name"] : "N/A" ?></td>
																			<td><?php echo isset($value["email"]) ? $value["email"] : "N/A" ?></td>
																			<td><?php echo isset($value["phone_number"]) ? $value["phone_number"] : "N/A" ?></td>
																			<td class="pe-0 text-end min-w-200px"><span class="fw-bold text-primary">
																					<div class="badge badge-light-success px-2 py-2">Associado:</div>
																				</span><span class="fs-7"><?php echo (new DateTime($value["link_date"]))->format("d/m/Y - H:i"); ?>h</span></td>
																			<td><a type="button" onclick="unlinkDoctor(this)" data-datatable-action="delete-row" data-name="<?php echo $value["doctor_name"] ?>" data-id="<?php echo $value["hashed_id_doctor"] ?>" class="btn btn-icon btn-bg-light btn-color-danger btn-active-light-danger rounded w-35px h-35px"><i class="ki-outline ki-minus-circle fs-2"></i></a></td>
																		</tr>
																	<?php } ?>
																</tbody>
															</table>
														</div>
													</div>
												</div>
											</div>

											<!-- Utentes Associados -->
											<div class="tab-pane fade" id="patients" role="tabpanel">
												<div class="card pt-4 mb-6 mb-xl-9">
													<div class="card-header border-0">
														<div class="card-title">
															<h2>Utentes Associados</h2>
														</div>
													</div>
													<div class="card-body py-0">
														<div class="table-responsive">
															<table class="table align-middle table-row-dashed fw-semibold text-gray-600 fs-6 gy-5" id="kt_table_customers_logs">
																<tbody>
																	<thead class="border-bottom border-gray-200 fs-7 fw-bold">
																		<tr class="text-start text-muted text-uppercase gs-0">
																			<th class="min-w-150px sorting">Nome</th>
																			<th class="min-w-150px sorting">Email</th>
																			<th class="min-w-80px sorting">Telemóvel</th>
																			<th class="min-w-80px sorting"></th>
																		</tr>
																	</thead>
																	<?php foreach ($health_unit_patients_data as $key => $value) { ?>
																		<tr>
																			<td><?php echo isset($value["patient_name"]) ? $value["patient_name"] : "N/A" ?></td>
																			<td><?php echo isset($value["email"]) ? $value["email"] : "N/A" ?></td>
																			<td><?php echo isset($value["phone_number"]) ? $value["phone_number"] : "N/A" ?></td>
																			<td class="pe-0 text-end"><span class="fw-bold text-primary">
																					<div class="badge badge-light-warning px-2 py-2">Associado:</div>
																				</span><span class="fs-7"><?php echo (new DateTime($value["link_date"]))->format("d/m/Y - H:i"); ?>h</span></td>
																			<td><a type="button" onclick="unlinkPatient(this)" data-datatable-action="delete-row" data-name="<?php echo $value["patient_name"] ?>" data-id="<?php echo $value["hashed_id_patient"] ?>" class="btn btn-icon btn-bg-light btn-color-danger btn-active-light-danger rounded w-35px h-35px"><i class="ki-outline ki-minus-circle fs-2"></i></a></td>
																		</tr>
																	<?php } ?>
																</tbody>
															</table>
														</div>
													</div>
												</div>
											</div>

											<!-- Consultas -->
											<div class="tab-pane fade" id="appointments" role="tabpanel">
												<div class="card">
													<div class="card-body">
														<div class="d-flex flex-column flex-md-row align-items-center justify-content-md-between flex-wrap mb-5 gap-4">
															<div class="d-flex align-items-center position-relative my-1 mb-2 mb-md-0">
																<span class="svg-icon svg-icon-1 position-absolute ms-5">
																	<i class="ki-outline ki-magnifier fs-2"></i>
																</span>
																<input type="text" data-datatable-action="search" class="form-control form-control-solid w-250px ps-15" placeholder="Pesquisar...">

																<div class="d-flex align-items-center gap-2 ms-2">
																	<button class="btn btn-icon btn-light" id="prev-date"><i class="las la-angle-left"></i></button>
																	<div class="d-flex align-items-center position-relative">
																		<span class="position-absolute ms-5 lh-1">
																			<i class="ki-outline ki-calendar fs-2"></i>
																		</span>
																		<input type="text" data-datatable-action="date" class="form-control form-control-solid w-200px ps-15" value="" placeholder="dd/mm/aaaa">
																	</div>
																	<button class="btn btn-icon btn-light" id="next-date"><i class="las la-angle-right"></i></button>
																</div>
															</div>

															<div class="d-flex flex-column flex-sm-row align-items-center justify-content-md-end gap-3">
																<!-- Sincronizar Tabela -->
																<button type="button" class="btn btn-icon btn-active-light-primary lh-1" data-datatable-action="sync" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" title="Sincronizar tabela">
																	<i class="ki-outline ki-arrows-circle fs-2"></i>
																</button>
															</div>
														</div>

														<div class="table-responsive">
															<table id="datatable" class="table align-middle gs-0 gy-4">
																<thead>
																	<tr class="fw-bold text-muted bg-light">
																		<th class="ps-4 fs-6 min-w-150px rounded-start" data-priority="1">Médico</th>
																		<th class="ps-4 fs-6 min-w-150px rounded-start" data-priority="2">Utente</th>
																		<th class="ps-4 fs-6 min-w-100px rounded-start" data-priority="4">Hora</th>
																		<th class="ps-4 fs-6 min-w-80px rounded-start" data-priority="5">Estado</th>
																	</tr>
																</thead>
																<tbody></tbody>
															</table>
														</div>
													</div>
												</div>
											</div>
											<!--end:::Tab pane-->
										</div>
										<!--end:::Tab content-->
									</div>
									<!--end::Content-->
								</div>

								<!-- Modal for Associate Doctors to HealtUnit -->
								<div class="modal fade" id="modal-associate-doctor" tabindex="-1" aria-modal="true" role="dialog">
									<div class="modal-dialog modal-dialog-centered mw-650px">
										<div class="modal-content">
											<div class="modal-header" id="modal-associate-doctor-header">
												<h3 class="fw-bold">Associar Médico à Unidade de Saúde - <?php echo $health_unit_data["name"]; ?></h3>
												<div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
													<i class="las la-times fs-1"></i>
												</div>
											</div>

											<div class="modal-body mx-5 mx-xl-15 my-7">
												<form id="modal-associate-doctor-form" class="form" action="#">
													<div class="d-flex flex-column me-n7 pe-7" id="modal-associate-doctor-form-scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#modal-edit-treatment-header" data-kt-scroll-wrappers="#modal-edit-treatment-form-scroll" data-kt-scroll-offset="350px" style="max-height: 91px;">
														<div class="row g-6">

															<div class="col-12">
																<div class="fv-row">
																	<label class="required fw-semibold fs-6">Selecione o Médico</label>
																	<select class="form-select form-select-solid" name="id_user" data-control="select2" data-placeholder="Selecione um Médico para Associar">
																		<option></option>
																		<?php foreach ($doctors_list as $key => $value) { ?>
																			<option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["first_name"] . ' ' . $value["last_name"] ?></option>
																		<?php } ?>
																	</select>
																</div>
															</div>

														</div>
													</div>

													<div class="text-center pt-15">
														<button type="reset" data-bs-dismiss="modal" class="btn btn-light me-3">Cancelar</button>
														<button type="submit" class="btn btn-light-primary">
															<span class="indicator-label">Associar</span>
															<span class="indicator-progress">Por Favor Aguarde...
																<span class="spinner-border spinner-border-sm align-middle ms-2"></span>
															</span>
														</button>
													</div>
												</form>
											</div>
										</div>
									</div>
								</div>

								<!-- Modal for Associate Patients to HealtUnit -->
								<div class="modal fade" id="modal-associate-patient" tabindex="-1" aria-modal="true" role="dialog">
									<div class="modal-dialog modal-dialog-centered mw-650px">
										<div class="modal-content">
											<div class="modal-header" id="modal-associate-patient-header">
												<h3 class="fw-bold">Associar Paciente à Unidade de Saúde - <?php echo $health_unit_data["name"]; ?></h3>
												<div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
													<i class="las la-times fs-1"></i>
												</div>
											</div>

											<div class="modal-body mx-5 mx-xl-15 my-7">
												<form id="modal-associate-patient-form" class="form" action="#">
													<div class="d-flex flex-column me-n7 pe-7" id="modal-associate-patient-form-scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#modal-edit-treatment-header" data-kt-scroll-wrappers="#modal-edit-treatment-form-scroll" data-kt-scroll-offset="350px" style="max-height: 91px;">
														<div class="row g-6">

															<div class="col-12">
																<div class="fv-row">
																	<label class="required fw-semibold fs-6">Selecione o Paciente</label>
																	<select class="form-select form-select-solid" name="id_user" data-control="select2" data-placeholder="Selecione um Paciente para Associar">
																		<option></option>
																		<?php foreach ($patients_list as $key => $value) { ?>
																			<option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["first_name"] . ' ' . $value["last_name"] ?></option>
																		<?php } ?>
																	</select>
																</div>
															</div>

														</div>
													</div>

													<div class="text-center pt-15">
														<button type="reset" data-bs-dismiss="modal" class="btn btn-light me-3">Cancelar</button>
														<button type="submit" class="btn btn-light-primary">
															<span class="indicator-label">Associar</span>
															<span class="indicator-progress">Por Favor Aguarde...
																<span class="spinner-border spinner-border-sm align-middle ms-2"></span>
															</span>
														</button>
													</div>
												</form>
											</div>
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
		const form = document.getElementById("modal-associate-doctor-form");
		form.addEventListener("submit", linkDoctor);

		const api_url = "http://localhost:3000/api/";
		const path = "health_unit/link_doctor";

		function linkDoctor() {
			event.preventDefault();

			var form = document.getElementById("modal-associate-doctor-form");

			const formData = {
				hashed_id_health_unit: "<?php echo $id_health_unit ?>",
				hashed_id_user: form.id_user.value,
			};


			fetch(api_url + path, {
					method: "POST",
					headers: {
						"Content-Type": "application/json",
					},
					body: JSON.stringify(formData),
				})
				.then((response) => response.json())
				.then((data) => {
					if (data.status) {
						Swal.fire({
							icon: "success",
							title: "Sucesso!",
							text: data.message,
							buttonsStyling: false,
							allowOutsideClick: false,
							didOpen: () => {
								const confirmButton = Swal.getConfirmButton();
								confirmButton.blur();
							},
							customClass: {
								confirmButton: "btn fw-bold btn-primary",
							},
						}).then((result) => {
							if (result.isConfirmed) {
								location.reload();
							}
						});
					} else {
						Swal.fire({
							icon: "error",
							title: "Ocorreu um Erro!",
							text: data.error,
							confirmButtonText: "Voltar a Edição",
							buttonsStyling: false,
							customClass: {
								confirmButton: "btn btn-danger",
							},
						});
					}
				})
				.catch((error) => {
					console.error("Error:", error);
				});
		}
	</script>

	<script>
		function unlinkDoctor(element) {
			event.preventDefault();

			const api_url2 = "http://localhost:3000/api/";
			const path2 = "health_unit/unlink_doctor";

			var userName = element.dataset.name;
			var userId = element.dataset.id;

			var form = document.getElementById("modal-unlink-doctor-form");

			const formData = {
				hashed_id_health_unit: "<?php echo $id_health_unit ?>",
				hashed_id_user: userId,
			};

			Swal.fire({
				icon: "warning",
				title: "Desassociar Médico!",
				html: `Tem a certeza que pretende desassociar o médico <b>${userName}</b> da Unidade de Saúde <b><?php echo $health_unit_data["name"]; ?></b>?`,
				confirmButtonText: "Sim, Desassociar!",
				cancelButtonText: "Não, Cancelar!",
				showCancelButton: true,
				reverseButtons: true,
				buttonsStyling: false,
				customClass: {
					confirmButton: "btn fw-bold btn-danger",
					cancelButton: "btn fw-bold btn-active-light-warning",
				},
			}).then(function(result) {
				if (result.value) {
					fetch(api_url2 + path2, {
							method: "POST",
							headers: {
								"Content-Type": "application/json",
							},
							body: JSON.stringify(formData),
						})
						.then((response) => response.json())
						.then((data) => {
							if (data.status) {
								Swal.fire({
									icon: "success",
									title: "Sucesso!",
									text: data.message,
									buttonsStyling: false,
									allowOutsideClick: false,
									didOpen: () => {
										const confirmButton = Swal.getConfirmButton();
										confirmButton.blur();
									},
									customClass: {
										confirmButton: "btn fw-bold btn-primary",
									},
								}).then((result) => {
									if (result.isConfirmed) {
										location.reload();
									}
								});
							} else {
								Swal.fire({
									icon: "error",
									title: "Ocorreu um Erro!",
									text: data.error,
									confirmButtonText: "Voltar",
									buttonsStyling: false,
									customClass: {
										confirmButton: "btn btn-danger",
									},
								});
							}
						})
						.catch((error) => {
							console.error("Error:", error);
						});
				} else if (result.dismiss === "cancel") {
					Swal.fire({
						icon: "error",
						title: "Cancelado!",
						text: "O Médico não foi desassociado da Unidade de Saúde.",
						confirmButtonText: "Voltar",
						buttonsStyling: false,
						customClass: {
							confirmButton: "btn btn-danger",
						},
					});
				}
			});
		}
	</script>

	<script>
		const form2 = document.getElementById("modal-associate-patient-form");
		form2.addEventListener("submit", linkPatient);

		const api_url3 = "http://localhost:3000/api/";
		const path3 = "health_unit/link_patient";

		function linkPatient() {
			event.preventDefault();

			var form2 = document.getElementById("modal-associate-patient-form");

			const formData = {
				hashed_id_health_unit: "<?php echo $id_health_unit ?>",
				hashed_id_user: form2.id_user.value,
			};

			fetch(api_url3 + path3, {
					method: "POST",
					headers: {
						"Content-Type": "application/json",
					},
					body: JSON.stringify(formData),
				})
				.then((response) => response.json())
				.then((data) => {
					if (data.status) {
						Swal.fire({
							icon: "success",
							title: "Sucesso!",
							text: data.message,
							buttonsStyling: false,
							allowOutsideClick: false,
							didOpen: () => {
								const confirmButton = Swal.getConfirmButton();
								confirmButton.blur();
							},
							customClass: {
								confirmButton: "btn fw-bold btn-primary",
							},
						}).then((result) => {
							if (result.isConfirmed) {
								location.reload();
							}
						});
					} else {
						Swal.fire({
							icon: "error",
							title: "Ocorreu um Erro!",
							text: data.error,
							confirmButtonText: "Voltar",
							buttonsStyling: false,
							customClass: {
								confirmButton: "btn btn-danger",
							},
						});
					}
				})
				.catch((error) => {
					console.error("Error:", error);
				});
		}
	</script>

	<script>
		// Unlink Patient on Health Unit
		function unlinkPatient(element) {
			event.preventDefault();

			const api_url4 = "http://localhost:3000/api/";
			const path4 = "health_unit/unlink_patient";

			var userName = element.dataset.name;
			var userId = element.dataset.id;

			var form = document.getElementById("modal-unlink-patient-form");

			const formData = {
				hashed_id_health_unit: "<?php echo $id_health_unit ?>",
				hashed_id_user: userId,
			};

			Swal.fire({
				icon: "warning",
				title: "Desassociar Utente!",
				html: `Tem a certeza que pretende desassociar o utente <b>${userName}</b> da Unidade de Saúde <b><?php echo $health_unit_data["name"]; ?></b>?`,
				confirmButtonText: "Sim, Desassociar!",
				cancelButtonText: "Não, Cancelar!",
				showCancelButton: true,
				reverseButtons: true,
				buttonsStyling: false,
				customClass: {
					confirmButton: "btn fw-bold btn-danger",
					cancelButton: "btn fw-bold btn-active-light-warning",
				},
			}).then(function(result) {
				if (result.value) {
					fetch(api_url4 + path4, {
							method: "POST",
							headers: {
								"Content-Type": "application/json",
							},
							body: JSON.stringify(formData),
						})
						.then((response) => response.json())
						.then((data) => {
							if (data.status) {
								Swal.fire({
									icon: "success",
									title: "Sucesso!",
									text: data.message,
									buttonsStyling: false,
									allowOutsideClick: false,
									didOpen: () => {
										const confirmButton = Swal.getConfirmButton();
										confirmButton.blur();
									},
									customClass: {
										confirmButton: "btn fw-bold btn-primary",
									},
								}).then((result) => {
									if (result.isConfirmed) {
										location.reload();
									}
								});
							} else {
								Swal.fire({
									icon: "error",
									title: "Ocorreu um Erro!",
									text: data.error,
									confirmButtonText: "Voltar",
									buttonsStyling: false,
									customClass: {
										confirmButton: "btn btn-danger",
									},
								});
							}
						})
						.catch((error) => {
							console.error("Error:", error);
						});
				} else if (result.dismiss === "cancel") {
					Swal.fire({
						icon: "error",
						title: "Cancelado!",
						text: "O Utente não foi desassociado da Unidade de Saúde.",
						confirmButtonText: "Voltar",
						buttonsStyling: false,
						customClass: {
							confirmButton: "btn btn-danger",
						},
					});
				}
			});
		}
	</script>

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
						url: "http://localhost:3000/api/appointments/table",
						type: "POST",
						contentType: "application/json",
						data: () => {
							return JSON.stringify({
								'start_date': moment(document.querySelector(`input[data-datatable-action="date"]`).value, "DD/MM/YYYY").format("YYYY-MM-DD"),
								'hashed_id_health_unit': "<?php echo $id_health_unit ?>"
							});
						}
					},
					columns: [{
							data: "doctor_first_name"
						},
						{
							data: "patient_first_name"
						},
						{
							data: "start_time"
						},
						{
							data: "appointment_status"
						},
					],
					columnDefs: [{
							targets: 0,
							orderable: true,
							render: (data, type, row) => {
								const doctor_name = row.doctor_first_name !== null && row.doctor_last_name !== null ? row.doctor_first_name + " " + row.doctor_last_name : 'Perfil sem nome';
								return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
											<span class="text-dark fw-bold text-hover-primary mb-1 fs-6 lh-sm">${doctor_name}</span>
										</div>
									</div>
								`
							},
						},
						{
							targets: 1,
							orderable: true,
							render: (data, type, row) => {
								const patient_name = row.patient_first_name !== null && row.patient_last_name !== null ? row.patient_first_name + " " + row.patient_last_name : 'Perfil sem nome';
								return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
										<span class="mb-1 fs-6 lh-sm">${patient_name}</span>
										</div>
									</div>
								`;

							},
						},
						{
							targets: 2,
							orderable: true,
							render: (data, type, row) => {

								const start_tim = moment(row.start_time, 'HH:mm:ss').format('HH:mm');
								const end_tim = moment(row.end_time, 'HH:mm:ss').format('HH:mm');

								const formattedHour = start_tim + 'h - ' + end_tim + 'h';
								return `
									<div class="d-inline-flex align-items-center">                                
										<div class="d-flex justify-content-center flex-column">
											<span class="mb-1 fs-6 lh-sm">${formattedHour}</span>
										</div>
									</div>
								`;
							},
						},
						{
							targets: 3,
							orderable: true,
							render: (data, type, row) => {
								if (row.appointment_status === 0) {
									return `
                            <div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="badge badge-info px-2 py-2">Pendente</span>
                                </div>
                            </div>
                        `
								} else if (row.appointment_status === 1) {
									return `<div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="badge badge-success px-2 py-2">Concluída</span>
                                </div>
                            </div>
                        `
								} else if (row.appointment_status === 2) {
									return `<div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="badge badge-warning px-2 py-2">Não Compareceu</span>
                                </div>
                            </div>
                        `
								} else if (row.appointment_status === 3) {
									return `<div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="badge badge-dark px-2 py-2">Cancelada</span>
                                </div>
                            </div>
                        `
								} else if (row.appointment_status === 4) {
									return `<div class="d-inline-flex align-items-center">                                
                                <div class="d-flex justify-content-center flex-column">
                                    <span class="badge badge-danger px-2 py-2">Eliminada</span>
                                </div>
                            </div>
                        `
								}
							},
						}
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
						title: "Desativar Utilizador",
						text: "Tem a certeza que deseja desativar o Utilizador (" + name + ") ?",
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

							fetch("http://localhost:3000/api/users/remove", options)
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

			var handleDateFilter = () => {
				const inputDate = document.querySelector(`input[data-datatable-action="date"]`);
				const nextDate = document.querySelector("#next-date");
				const prevDate = document.querySelector("#prev-date");

				$(inputDate).flatpickr({
					dateFormat: "d/m/Y",
					locale: "pt",
					disableMobile: true,
					allowInput: true,
					allowClear: false,
					defaultDate: new Date()
				});

				inputDate.addEventListener("change", (e) => dt.ajax.reload());

				nextDate.addEventListener("click", (e) => {
					const date = moment(inputDate.value, "DD/MM/YYYY");
					date.add(1, "days");
					inputDate.value = date.format("DD/MM/YYYY");
					inputDate.dispatchEvent(new Event("change"));
				});
				prevDate.addEventListener("click", (e) => {
					const date = moment(inputDate.value, "DD/MM/YYYY");
					date.subtract(1, "days");
					inputDate.value = date.format("DD/MM/YYYY");
					inputDate.dispatchEvent(new Event("change"));
				});
			};

			var handleFilterDatatable = () => {
				const filterButton = document.querySelector(`[data-datatable-action="filter"]`);

				filterButton.addEventListener("click", () => {
					dt.ajax.reload()
				});
			};

			return {
				init: () => {
					initDatatable()
					handleSyncDatatable()
					handleSearchDatatable()
					handleDeleteRows()
					handleDateFilter()
					handleFilterDatatable()
				},
			}
		})()

		window.addEventListener("DOMContentLoaded", () => {
			datatableServerSide.init()
		})
	</script>

</body>

</html>