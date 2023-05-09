<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$id_health_unit = $_GET["id"];
$api = new Api();
$health_unit_info = $api->fetch("health_unit/", null, $id_health_unit);
$health_unit_data = $health_unit_info["response"];

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
											<!--begin:::Tab item-->
											<li class="nav-item" role="presentation">
												<a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" href="#kt_customer_view_overview_tab" aria-selected="true" role="tab">Utentes</a>
											</li>
											<!--end:::Tab item-->
											<!--begin:::Tab item-->
											<li class="nav-item" role="presentation">
												<a class="nav-link text-active-primary pb-4" data-bs-toggle="tab" href="#kt_customer_view_overview_events_and_logs_tab" aria-selected="false" role="tab" tabindex="-1">Médicos</a>
											</li>
											<!--end:::Tab item-->
											<!--begin:::Tab item-->
											<li class="nav-item" role="presentation">
												<a class="nav-link text-active-primary pb-4" data-kt-countup-tabs="true" data-bs-toggle="tab" href="#kt_customer_view_overview_statements" data-kt-initialized="1" aria-selected="false" role="tab" tabindex="-1">Consultas</a>
											</li>
											<!--end:::Tab item-->
										</ul>
										<!--end:::Tabs-->
										<!--begin:::Tab content-->
										<div class="tab-content" id="myTabContent">
											<!--begin:::Tab pane-->
											<div class="tab-pane fade active show" id="kt_customer_view_overview_tab" role="tabpanel">
												<h1>Utentes</h1>
											</div>
											<!--end:::Tab pane-->
											<!--begin:::Tab pane-->
											<div class="tab-pane fade" id="kt_customer_view_overview_events_and_logs_tab" role="tabpanel">
												<h1>Médicos</h1>
											</div>
											<!--end:::Tab pane-->
											<!--begin:::Tab pane-->
											<div class="tab-pane fade" id="kt_customer_view_overview_statements" role="tabpanel">
												<h1>Consultas</h1>
											</div>
											<!--end:::Tab pane-->
										</div>
										<!--end:::Tab content-->
									</div>
									<!--end::Content-->
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