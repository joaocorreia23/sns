<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php

$get_tab = isset($_GET["tab"]) ? $_GET["tab"] : "appointment_tab_1";

$id_appointment = $_GET["id"];
$api = new Api();
$appointment_info = $api->fetch("appointments", null, $id_appointment);
if (!$appointment_info['status']) {
	header("Location: /pages/admin/appointments/list");
	exit();
} else {
	$appointment_info = $appointment_info["response"]['data'];
}
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
														<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/details.php"); ?>
													</div>
													<div id="medication" class="py-0 tab-pane fade" role="tabpanel">
														<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/medications.php"); ?>
													</div>
													<div id="exams" class="py-0 tab-pane fade" role="tabpanel">
														<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/exams.php"); ?>
													</div>
													<div id="vaccines" class="py-0 tab-pane fade" role="tabpanel">
														<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/vaccines.php"); ?>
													</div>
												</div>
												<!--end:::Tab content-->
											</div>
											<!--end::Content-->
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


</body>

</html>