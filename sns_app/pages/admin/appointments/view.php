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

$medication = $api->fetch("medications/", null, null);
$medication_list = $medication["response"];


$page_name = $appointment_info["title"] . ' - ' . (new DateTime($appointment_info["start"]))->format("d/m/Y");;
?>
<style>
	textarea {
		resize: none;
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
																		<?php echo $appointment_info["doctor_number"] ?>
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
																		<?php echo $appointment_info["patient_number"] ?>
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

																<div class="fw-bold mt-5">Número de Utente</div>
																<div class="text-gray-600"><?php echo $appointment_info["patient_number"] ?></div>

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
													<?php if ($appointment_info["appointment_status"] === 0) { ?>
														<li class="nav-item ms-auto">
															<a class="btn btn-primary ps-7" data-kt-menu-trigger="click" data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">Prescrever
																<i class="ki-outline ki-down fs-2 me-0"></i></a>
															<div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg-light-primary fw-semibold py-4 w-250px fs-6" data-kt-menu="true" style="">
																<div class="menu-item px-5">
																	<div class="menu-content text-muted pb-2 px-5 fs-7 text-uppercase">Prescrever:</div>
																</div>
																<div class="menu-item px-5">
																	<a data-bs-toggle="modal" data-bs-target="#modal-prescriptions" class="menu-link px-5">Medicação</a>
																</div>
																<div class="menu-item px-5">
																	<a data-bs-toggle="modal" data-bs-target="#modal-exams" class="menu-link px-5">Exames</a>
																</div>
																<div class="menu-item px-5">
																	<a data-bs-toggle="modal" data-bs-target="#modal-vaccines" class="menu-link px-5">Vacinas</a>
																</div>
															</div>
														</li>
													<?php } ?>
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

										<!-- Modal for add Prescription to Patient -->
										<div class="modal fade" id="modal-prescriptions" tabindex="-1" aria-modal="true" role="dialog">
											<form id="modal-prescriptions-form" class="form" action="#">
												<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
													<div class="modal-content">
														<div class="modal-header" id="modal-prescriptions-header">
															<h3 class="fw-bold">Prescrever Medicação ao Utente - <?php echo $appointment_info["patient_first_name"]; ?></h3>
															<div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
																<i class="las la-times fs-1"></i>
															</div>
														</div>

														<div class="modal-body mx-5 mx-xl-15 my-5">
															<div class="d-flex flex-column me-n7 pe-7" id="modal-prescriptions-form-scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#modal-edit-treatment-header" data-kt-scroll-wrappers="#modal-edit-treatment-form-scroll" data-kt-scroll-offset="350px" style="max-height: 91px;">
																<div class="row g-6">
																	<!--begin::Repeater-->
																	<div id="medication_repeater">
																		<div data-repeater-list="medication_repeater">
																			<div data-repeater-item class="border-bottom mb-6">
																				<div class="form-group row mb-5">
																					<div class="col-md-9 row gy-4">
																						<div class="col-md-12">
																							<label class="form-label required">Medicação</label>
																							<select name="hashed_id_medication" class="form-select mb-2" data-kt-repeater="select2" data-control="select2" data-placeholder="Selecione uma Medicação" data-hide-search="false" data-allow-clear="true" required>
																								<option></option>
																								<?php foreach($medication_list as $key=>$medication){ ?>
																									<option value="<?php echo $medication["hashed_id"]; ?>"><?php echo $medication["medication_name"]; ?></option>
																								<?php } ?>
																							</select>
																						</div>
																						<div class="col-md-6">
																							<label class="form-label required">Quantidade</label>
																							<input type="number" step="1" name="prescribed_amount" class="form-control" placeholder="Insira a Quantidade Prescrita" required />
																						</div>
																						<div class="col-md-6 form-check mt-4 mt-md-13">
																							<div class="ms-4">
																								<input class="form-check-input" type="checkbox" value="1" name="usual_medication" />
																								<label class="form-check-label" for="usual_medication">
																									Medicação Habitual
																								</label>
																							</div>
																						</div>
																						<div class="col-md-12">
																							<label class="form-label required">Instruções</label>
																							<textarea name="instructions" class="form-control" rows="2" placeholder="Insira as Instruções para a utilização da Medicação" required></textarea>
																						</div>
																					</div>
																					<div class="col-md-3 mt-4 mt-md-8">
																						<a href="javascript:;" data-repeater-delete class="btn btn-danger mt-3 mt-md-8">
																							<span class="svg-icon svg-icon-muted svg-icon-hx"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
																									<path d="M5 9C5 8.44772 5.44772 8 6 8H18C18.5523 8 19 8.44772 19 9V18C19 19.6569 17.6569 21 16 21H8C6.34315 21 5 19.6569 5 18V9Z" fill="currentColor" />
																									<path opacity="0.5" d="M5 5C5 4.44772 5.44772 4 6 4H18C18.5523 4 19 4.44772 19 5V5C19 5.55228 18.5523 6 18 6H6C5.44772 6 5 5.55228 5 5V5Z" fill="currentColor" />
																									<path opacity="0.5" d="M9 4C9 3.44772 9.44772 3 10 3H14C14.5523 3 15 3.44772 15 4V4H9V4Z" fill="currentColor" />
																								</svg>
																							</span>
																							Remover
																						</a>
																					</div>
																				</div>

																			</div>
																		</div>


																		<!--begin::Form group-->
																		<div class="form-group mt-5">
																			<a href="javascript:;" data-repeater-create class="btn btn-light-primary">
																				<span class="svg-icon svg-icon-muted svg-icon-hx">
																					<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
																						<rect opacity="0.3" x="2" y="2" width="20" height="20" rx="5" fill="currentColor" />
																						<rect x="10.8891" y="17.8033" width="12" height="2" rx="1" transform="rotate(-90 10.8891 17.8033)" fill="currentColor" />
																						<rect x="6.01041" y="10.9247" width="12" height="2" rx="1" fill="currentColor" />
																					</svg>
																				</span>
																				Adicionar Medicação
																			</a>
																		</div>
																		<!--end::Form group-->
																	</div>
																	<!--end::Repeater-->
																</div>
															</div>

														</div>
														<div class="modal-footer d-flex justify-content-center">
															<button type="reset" data-bs-dismiss="modal" class="btn btn-light me-3">Cancelar</button>
															<button type="submit" id="modal-prescriptions-form-button" class="btn btn-light-primary">
																<span class="indicator-label">Prescrever</span>
																<span class="indicator-progress">Por Favor Aguarde...
																	<span class="spinner-border spinner-border-sm align-middle ms-2"></span>
																</span>
															</button>
														</div>
													</div>

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
	<script src="<?php echo $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['SERVER_NAME'] . '/'; ?>/assets/plugins/custom/formrepeater/formrepeater.bundle.js"></script>

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

	<script>
		$('#medication_repeater').repeater({
			initEmpty: false,
			defaultValues: {
				'text-input': 'foo'
			},
			show: function() {
				$(this).slideDown();
				// Re-init select2
				$('[data-kt-repeater="select2"]').select2({
					placeholder: "Selecione uma Medicação",
					allowClear: false
				});

			},

			hide: function(deleteElement) {
				if($('#medication_repeater').find('[data-kt-repeater="select2"]').length > 1){
					$(this).slideUp(deleteElement);
				}else{
					toastr.error('É necessário pelo menos uma Medicação', 'Erro!');
				}
			}
		});

		//PREVENT USER FROM SELECTING SAME SPECIALTY TWICE
		$('#medication_repeater').on('change', '[data-kt-repeater="select2"]', function() {
			// Get the current select2 instance
			var $this = $(this);
			// Get all select2 instances
			var selects = $('#medication_repeater').find('[data-kt-repeater="select2"]');
			// Get all selected values
			var selected = selects.filter(function() {
				return $(this).val() == $this.val();
			});
			// If there are more than one selected value, reset the current select2
			if (selected.length > 1 && $this.val() != '') {
				$this.val('').trigger('change');
				//ADD ERROR MESSAGE
				toastr.error('Não é possivel selecionar a mesma Medicação duas vezes', 'Erro!');
			}
		});

		const form3 = document.getElementById("modal-prescriptions-form");
		form3.addEventListener("submit", addPrescription);

		const api_url3 = "http://localhost:3000/api/";
		const path3 = "prescriptions/insert_new";

		function addPrescription() {
			event.preventDefault();
	

			var form = document.getElementById("modal-prescriptions-form");

			const formData = {
				hashed_id_appointment: "<?php echo $id_appointment ?>",
			};

			var medications_list = [];

			

			$('#medication_repeater').find('[data-kt-repeater="select2"]').each(function() {
				var medication_hashed_id = $(this).val();
				var use_description = $(this).parent().parent().children().eq(3).children().eq(2).val();
				var prescribed_amount = parseInt($(this).parent().parent().children().eq(1).children().eq(1).val());
				var usual_medication = $(this).parent().parent().children().eq(2).children().children().eq(0).is(":checked");
				var medication = {
					hashed_id_medication: medication_hashed_id,
					use_description: use_description,
					prescribed_amount: prescribed_amount,
					usual_medication: usual_medication
				};
				medications_list.push(medication);
			});

			console.table(medications_list);

			fetch(api_url3 + path3, {
					method: "POST",
					headers: {
						"Content-Type": "application/json",
					},
					body: JSON.stringify({hashed_id_appointment: "6b51d431df5d7f141cbececcf79edf3dd861c3b4069f0b11661a3eefacbba918", prescription_medications: medications_list}),
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