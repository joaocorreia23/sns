<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php

$get_tab = isset($_GET["tab"]) ? $_GET["tab"] : "appointment_tab_1";

$id_appointment = $_GET["id"];
$api = new Api();
$appointment_info = $api->fetch("appointments", null, $id_appointment);

if (!$appointment_info['status']) {
	// header("Location: /pages/admin/appointments/list");
	// exit();
} else {
	$appointment_info = $appointment_info["response"]['data'];
}

$vaccines = $api->fetch("vaccines/", null, null);
$vaccines_list = $vaccines["response"];

$exams = $api->fetch("exams/", null, null);
$exams_list = $exams["response"];


$page_name = $appointment_info["title"] . ' - ' . (new DateTime($appointment_info["start"]))->format("d/m/Y");;
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
								<div class="card h-100">
									<div class="card-body pt-9 pb-0 d-flex flex-column justify-content-between">

										<div class="d-flex flex-column flex-xl-row gap-7">
											<!--begin::Order details-->
											<div class="card card-flush py-4 flex-row-fluid">
												<!--begin::Card header-->
												<div class="card-header">
													<div class="card-title">
														<h2>Consulta</h2>
													</div>
												</div>
												<!--end::Card header-->
												<!--begin::Card body-->
												<div class="card-body pt-0">
													<div class="table-responsive">
														<!--begin::Table-->
														<table class="table table-row-bordered mb-0 fs-6 gy-5 min-w-300px">
															<tbody class="fw-semibold text-gray-600 w-100 align-middle">
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-bank fs-2 me-2"></i></span>
																		<?php echo $appointment_info["health_unit_name"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-sms fs-2 me-2"></i></span>
																		<?php echo $appointment_info["health_unit_email"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-phone fs-2 me-2"></i></span>
																		<?php echo $appointment_info["health_unit_phone_number"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-information-2 fs-2 me-2"></i></span>
																		<?php if ($appointment_info["appointment_status"] === 0) {
																			echo ' <div class="d-inline-flex align-items-center">                                
																			<div class="d-flex justify-content-center flex-column">
																				<span class="badge badge-info px-2 py-2">Pendente</span>
																			</div>
																		</div>';
																		} else if ($appointment_info["appointment_status"] === 1) {
																			echo '<div class="d-inline-flex align-items-center">                                
																			<div class="d-flex justify-content-center flex-column">
																				<span class="badge badge-success px-2 py-2">Concluída</span>
																			</div>
																		</div>';
																		} else if ($appointment_info["appointment_status"] === 2) {
																			echo '<div class="d-inline-flex align-items-center">                                
																			<div class="d-flex justify-content-center flex-column">
																				<span class="badge badge-warning px-2 py-2">Não Compareceu</span>
																			</div>';
																		} else if ($appointment_info["appointment_status"] === 3) {
																			echo `<div class="d-inline-flex align-items-center">                                
																			<div class="d-flex justify-content-center flex-column">
																				<span class="badge badge-dark px-2 py-2">Cancelada</span>
																			</div>
																		</div>`;
																		} else if ($appointment_info["appointment_status"] === 4) {
																			echo '<div class="d-inline-flex align-items-center">                                
																			<div class="d-flex justify-content-center flex-column">
																				<span class="badge badge-danger px-2 py-2">Eliminada</span>
																			</div>
																		</div>';
																		}
																		?>
																	</td>
																</tr>
															</tbody>
														</table>
														<!--end::Table-->
													</div>
												</div>
												<!--end::Card body-->
											</div>
											<!--end::Order details-->
											<!--begin::Customer details-->
											<div class="card card-flush py-4 flex-row-fluid">
												<!--begin::Card header-->
												<div class="card-header">
													<div class="card-title">
														<h2>Médico</h2>
													</div>
												</div>
												<!--end::Card header-->
												<!--begin::Card body-->
												<div class="card-body pt-0">
													<div class="table-responsive">
														<!--begin::Table-->
														<table class="table table-row-bordered mb-0 fs-6 gy-5 min-w-300px">
															<tbody class="fw-semibold text-gray-600 w-100 align-middle">
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-bank fs-2 me-2"></i></span>
																		<?php echo $appointment_info["doctor_first_name"] . ' ' . $appointment_info["doctor_last_name"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-sms fs-2 me-2"></i></span>
																		<?php echo $appointment_info["doctor_email"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-phone fs-2 me-2"></i></span>
																		<?php echo $appointment_info["doctor_phone_number"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-wallet fs-2 me-2"></i></span>
																		Cedula Médico Por Fazer
																	</td>
																</tr>
															</tbody>
														</table>
														<!--end::Table-->
													</div>
												</div>
												<!--end::Card body-->
											</div>
											<!--end::Customer details-->
											<!--begin::Documents-->
											<div class="card card-flush py-4 flex-row-fluid">
												<!--begin::Card header-->
												<div class="card-header">
													<div class="card-title">
														<h2>Utente</h2>
													</div>
												</div>
												<!--end::Card header-->
												<!--begin::Card body-->
												<div class="card-body pt-0">
													<div class="table-responsive">
														<!--begin::Table-->
														<table class="table table-row-bordered mb-0 fs-6 gy-5 min-w-300px">
															<tbody class="fw-semibold text-gray-600 w-100 align-middle">
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-bank fs-2 me-2"></i></span>
																		<?php echo $appointment_info["patient_first_name"] . ' ' . $appointment_info["patient_last_name"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-sms fs-2 me-2"></i></span>
																		<?php echo $appointment_info["patient_email"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-phone fs-2 me-2"></i></span>
																		<?php echo $appointment_info["patient_phone_number"] ?>
																	</td>
																</tr>
																<tr>
																	<td class="fw-bold d-flex">
																		<span class="text-muted me-2"><i class="ki-outline ki-wallet fs-2 me-2"></i></span>
																		Numero Utente Por Fazer
																	</td>
																</tr>
															</tbody>
														</table>
														<!--end::Table-->
													</div>
												</div>
												<!--end::Card body-->
											</div>
											<!--end::Documents-->
										</div>

										<div class="separator separator-content border-dark my-15"><span class="w-250px fw-bold text-primary">Informação Completa da Consulta</span></div>


										<div class="d-flex flex-column flex-xl-row mt-6">
											<!--begin::Sidebar-->
											<div class="flex-column flex-lg-row-auto w-100 w-xl-350px mb-10">
												<!--begin::Card-->
												<div class="card mb-5 mb-xl-8">
													<!--begin::Card body-->
													<div class="card-body pt-15">
														<!--begin::Summary-->
														<div class="d-flex flex-center flex-column mb-5">
															<!--begin::Name-->
															<a href="#" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-1"><?php echo $appointment_info["title"] ?></a>
															<!--end::Name-->
															<!--begin::Position-->
															<div class="fs-6 fw-semibold text-muted mb-1"><?php echo $appointment_info["health_unit_name"] ?></div>
															<div class="fs-6 fw-semibold text-muted mb-4"><?php echo (new DateTime($appointment_info["start"]))->format("d/m/Y"); ?></div>
															<div class="fs-6 fw-semibold text-muted mb-4"><?php echo (new DateTime($appointment_info["start_time"]))->format("H:i") . ' - ' . (new DateTime($appointment_info["end_time"]))->format("H:i") ?></div>

															<!--end::Position-->
															<?php if ($appointment_info["appointment_status"] === 0) {
																echo '<span class="badge badge-info px-2 py-2">Pendente</span>';
															} else if ($appointment_info["appointment_status"] === 1) {
																echo '<span class="badge badge-success px-2 py-2">Concluída</span>';
															} else if ($appointment_info["appointment_status"] === 2) {
																echo '<span class="badge badge-warning px-2 py-2">Não Compareceu</span>';
															} else if ($appointment_info["appointment_status"] === 3) {
																echo `<span class="badge badge-dark px-2 py-2">Cancelada</span>`;
															} else if ($appointment_info["appointment_status"] === 4) {
																echo '<span class="badge badge-danger px-2 py-2">Eliminada</span>';
															}
															?>
														</div>
														<!--end::Summary-->
														<!--begin::Details toggle-->
														<div class="d-flex flex-stack fs-4 py-3">
															<div class="fw-bold rotate collapsible active" data-bs-toggle="collapse" href="#kt_customer_view_details" role="button" aria-expanded="true" aria-controls="kt_customer_view_details">Detalhes Utente
																<span class="ms-2 rotate-180">
																	<i class="ki-outline ki-down fs-3"></i>
																</span>
															</div>
														</div>
														<!--end::Details toggle-->
														<div class="separator separator-dashed my-3"></div>
														<!--begin::Details content-->
														<div id="kt_customer_view_details" class="collapse show">
															<div class="py-5 fs-6">

																<div class="fw-bold mt-5">Nome Completo</div>
																<div class="text-gray-600"><?php echo $appointment_info["patient_first_name"] . ' ' . $appointment_info["patient_last_name"] ?></div>

																<div class="fw-bold mt-5">Email</div>
																<div class="text-gray-600"><?php echo $appointment_info["patient_email"] ?></div>

																<div class="fw-bold mt-5">Contacto Telefónico</div>
																<div class="text-gray-600"><?php echo $appointment_info["patient_phone_number"] ?></div>

																<div class="fw-bold mt-5">NIF</div>
																<div class="text-gray-600"><?php echo $appointment_info["patient_tax_number"] ?></div>

																<div class="fw-bold mt-5">Género</div>
																<span class="badge badge-warning"><?php echo $appointment_info["patient_gender"] ?></span>

																<div class="fw-bold mt-5">Nascido(a) em:</div>
																<div class="text-gray-600"><?php echo (new DateTime($appointment_info["patient_birth_date"]))->format("d/m/Y - H:i"); ?></div>
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
														<a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" role="tab" href="#info" aria-selected="false" tabindex="-1">Outra Informação</a>
													</li>
													<li class="nav-item" role="presentation">
														<a class="nav-link text-active-primary pb-4" data-bs-toggle="tab" role="tab" href="#medication" aria-selected="false" tabindex="-1">Medicação</a>
													</li>
													<li class="nav-item" role="presentation">
														<a class="nav-link text-active-primary pb-4" data-bs-toggle="tab" role="tab" href="#exams" aria-selected="false" tabindex="-1">Exames</a>
													</li>
													<li class="nav-item" role="presentation">
														<a class="nav-link text-active-primary pb-4" data-bs-toggle="tab" role="tab" href="#vaccines" aria-selected="false" tabindex="-1">Vacinas</a>
													</li>
												</ul>
												<!--end:::Tabs-->
												<!--begin:::Tab content-->
												<div class="tab-content" id="myTabContent">

													<div id="info" class="py-0 tab-pane fade show active" role="tabpanel">
														<?php require($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/details.php"); ?>
													</div>
													<div id="medication" class="py-0 tab-pane fade" role="tabpanel">
														<?php require($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/medications.php"); ?>
													</div>
													<div id="exams" class="py-0 tab-pane fade" role="tabpanel">
														<?php require($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/exams.php"); ?>
													</div>
													<div id="vaccines" class="py-0 tab-pane fade" role="tabpanel">
														<?php require($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/vaccines.php"); ?>
													</div>
												</div>
												<!--end:::Tab content-->
											</div>
											<!--end::Content-->
										</div>

										<!-- MODALS -->
										<!-- Modal for add Vaccine to Patient -->
										<div class="modal fade" id="modal-vaccines" tabindex="-1" aria-modal="true" role="dialog">
											<div class="modal-dialog modal-dialog-centered mw-650px">
												<div class="modal-content">
													<div class="modal-header" id="modal-vaccines-header">
														<h3 class="fw-bold">Prescrever uma Vacina ao Utente - <?php echo $appointment_info["patient_first_name"]; ?></h3>
														<div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
															<i class="las la-times fs-1"></i>
														</div>
													</div>

													<div class="modal-body mx-5 mx-xl-15 my-7">
														<form id="modal-vaccines-form" class="form" action="#">
															<div class="d-flex flex-column me-n7 pe-7" id="modal-vaccines-form-scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#modal-edit-treatment-header" data-kt-scroll-wrappers="#modal-edit-treatment-form-scroll" data-kt-scroll-offset="350px" style="max-height: 91px;">
																<div class="row g-6">

																	<div class="col-12">
																		<div class="fv-row">
																			<label class="required fw-semibold fs-6">Selecione a Vacina</label>
																			<select class="form-select form-select-solid" name="id_vaccine" data-control="select2" data-placeholder="Selecione uma Vacina para Prescrever">
																				<option></option>
																				<?php foreach ($vaccines_list as $key => $value) { ?>
																					<option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["vaccine_name"] ?></option>
																				<?php } ?>
																			</select>
																		</div>
																	</div>

																	<div class="col-6">
																		<div class="fv-row">
																			<label class="required fw-semibold fs-6">Dosagem</label>
																			<input type="number" step="0.01" class="form-control form-control-solid" placeholder="Insira a Dosagem" name="dosage" />
																		</div>
																	</div>

																	<div class="col-6">
																		<div class="fv-row mt-8 ms-4">
																			<div class="form-check form-check-custom form-check-success form-check-solid">
																				<input class="form-check-input" type="checkbox" name="administered" id="administered" value="" />
																				<label class="form-check-label" for="administered">
																					Administrada
																				</label>
																			</div>
																		</div>
																	</div>

																</div>
															</div>

															<div class="text-center pt-15">
																<button type="reset" data-bs-dismiss="modal" class="btn btn-light me-3">Cancelar</button>
																<button type="submit" id="submit_vaccine" class="btn btn-light-primary">
																	<span class="indicator-label">Prescrever</span>
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

										<!-- Modal for add Exam to Patient -->
										<div class="modal fade" id="modal-exams" tabindex="-1" aria-modal="true" role="dialog">
											<div class="modal-dialog modal-dialog-centered mw-650px">
												<div class="modal-content">
													<div class="modal-header" id="modal-exams-header">
														<h3 class="fw-bold">Prescrever um Exame ao Utente - <?php echo $appointment_info["patient_first_name"]; ?></h3>
														<div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
															<i class="las la-times fs-1"></i>
														</div>
													</div>

													<div class="modal-body mx-5 mx-xl-15 my-7">
														<form id="modal-exams-form" class="form" action="#">
															<div class="d-flex flex-column me-n7 pe-7" id="modal-exams-form-scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#modal-edit-treatment-header" data-kt-scroll-wrappers="#modal-edit-treatment-form-scroll" data-kt-scroll-offset="350px" style="max-height: 91px;">
																<div class="row g-6">

																	<div class="col-12">
																		<div class="fv-row">
																			<label class="required fw-semibold fs-6">Selecione um Exame</label>
																			<select class="form-select form-select-solid" name="id_exam" data-control="select2" data-placeholder="Selecione o Exame para Prescrever">
																				<option></option>
																				<?php foreach ($exams_list as $key => $value) { ?>
																					<option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["exam_name"] ?></option>
																				<?php } ?>
																			</select>
																		</div>
																	</div>

																</div>
															</div>

															<div class="text-center pt-15">
																<button type="reset" data-bs-dismiss="modal" class="btn btn-light me-3">Cancelar</button>
																<button type="submit" class="btn btn-light-primary">
																	<span class="indicator-label">Prescrever</span>
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
		const form = document.getElementById("modal-vaccines-form");
		form.addEventListener("submit", addVaccine);

		const api_url = "http://localhost:3000/api/";
		const path = "vaccines/administered/insert";

		function addVaccine() {
			event.preventDefault();
			var form = document.getElementById("modal-vaccines-form");

			const currentDate = new Date();

			const formData = {
				hashed_id_appointment: "<?php echo $id_appointment ?>",
				hashed_id_vaccine: form.id_vaccine.value,
				administered_date: form.administered.checked ? currentDate : null,
				dosage: form.dosage.value,
				due_date: null,
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
		const form2 = document.getElementById("modal-exams-form");
		form2.addEventListener("submit", addExam);

		const api_url2 = "http://localhost:3000/api/";
		const path2 = "exams/prescribed/insert";

		function addExam() {
			event.preventDefault();
			var form = document.getElementById("modal-exams-form");


			const formData = {
				hashed_id_appointment: "<?php echo $id_appointment ?>",
				hashed_id_exam: form.id_exam.value,
			};


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

</body>

</html>