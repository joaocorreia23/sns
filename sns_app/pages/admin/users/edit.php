<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$id = isset($_GET["id"]) && !empty($_GET["id"]) ? $_GET["id"] : null;
$api = new Api();
$user_info = $api->fetch("users/", null, $id);
$user_info_data = $user_info["response"];
?>
<?php $page_name = "Editar Utilizador - " . $user_info_data["username"]?>

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
								<div class="card mb-5 mb-xl-10">
									<!--begin::Card header-->
									<div class="card-header border-0 cursor-pointer" role="button" data-bs-toggle="collapse" data-bs-target="#kt_account_profile_details" aria-expanded="true" aria-controls="kt_account_profile_details">
										<!--begin::Card title-->
										<div class="card-title m-0">
											<h3 class="fw-bold m-0">Editar Utilizador</h3>
										</div>
										<!--end::Card title-->
									</div>
									<!--begin::Card header-->
									<!--begin::Content-->
									<div id="kt_account_settings_profile_details" class="collapse show">
										<!--begin::Form-->
										<form id="form-edit-user" class="form fv-plugins-bootstrap5 fv-plugins-framework" novalidate="novalidate">
											<!--begin::Card body-->
											<div class="card-body border-top p-9">

												<div class="row mb-6">
													<div class="col-12 col-lg-6">
														<label class="col-lg-12 col-form-label required fw-semibold fs-6">Username</label>
														<div class="col-lg-12 fv-row fv-plugins-icon-container">
															<input type="text" name="username" class="form-control form-control-lg form-control-solid" placeholder="Nome do Utilizador" value="<?php echo $user_info_data["username"] ?>">
															<div class="fv-plugins-message-container invalid-feedback"></div>
														</div>
													</div>
													<div class="col-12 col-lg-6">
														<label class="col-lg-12 col-form-label required fw-semibold fs-6">Email</label>
														<div class="col-lg-12 fv-row fv-plugins-icon-container">
															<input type="text" name="email" class="form-control form-control-lg form-control-solid" placeholder="Email do Utilizador" value="<?php echo $user_info_data["email"] ?>">
															<div class="fv-plugins-message-container invalid-feedback"></div>
														</div>
													</div>
												</div>

											</div>
											<!--end::Card body-->
											<!--begin::Actions-->
											<div class="card-footer d-flex justify-content-end py-6 px-9">
												<button type="reset" class="btn btn-light btn-active-light-primary me-2">Cancelar</button>
												<button type="submit" class="btn btn-primary" id="kt_account_profile_details_submit">Guardar</button>
											</div>
											<!--end::Actions-->
											<input type="hidden">
										</form>
										<!--end::Form-->
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

	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const form = document.getElementById("form-edit-user");
			form.addEventListener("submit", editUser);

			const api_url = "http://localhost:3000/api/";
			const path = "users/";

			function editUser() {
				event.preventDefault();

				var form = document.getElementById("form-edit-user");

				const formData = {
                    hashed_id: "<?php echo $id ?>",
					username: form.username.value,
					email: form.email.value,
				};


				fetch(api_url + path + "update", {
						method: "PUT",
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
									window.location.href = "list";
								}
							});
						} else {
							console.log(JSON.stringify(formData)),
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
		});
	</script>

</body>

</html>