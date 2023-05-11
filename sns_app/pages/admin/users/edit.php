<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$id = isset($_GET["id"]) && !empty($_GET["id"]) ? $_GET["id"] : null;
$api = new Api();
$user_info = $api->fetch("users/", null, $id);
$user_info_data = $user_info["response"];
?>
<?php $page_name = "Editar Utilizador" ?>

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

                            <pre><?php print_r($user_info_data) ?></pre>

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
										<form id="form-add-user" class="form fv-plugins-bootstrap5 fv-plugins-framework" novalidate="novalidate">
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
													<div class="col-12 col-lg-6">
														<label for="modal-add-user-form-password" class="col-form-label form-label fw-semibold fs-6 required">Palavra-passe</label>
														<div class="fv-row password-meter">
															<div class="position-relative mb-3">
																<?php
																$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*_";
																$generated_password = substr(str_shuffle($chars), 0, 8) . "!";
																?>

																<input type="password" name="password" id="modal-add-user-form-password" class="form-control form-control-lg form-control-solid" value="<?php echo $generated_password; ?>" placeholder="" autocomplete="off">
																<span class="btn btn-sm btn-icon position-absolute translate-middle top-50 end-0 me-n2" data-kt-password-meter-control="visibility">
																	<i class="ki-outline ki-eye fs-2"></i>
																	<i class="ki-outline ki-eye-slash fs-2 d-none"></i>
																</span>
															</div>

															<div class="d-flex align-items-center mb-3" data-kt-password-meter-control="highlight">
																<div class="flex-grow-1 bg-secondary bg-active-success rounded h-5px me-2"></div>
																<div class="flex-grow-1 bg-secondary bg-active-success rounded h-5px me-2"></div>
																<div class="flex-grow-1 bg-secondary bg-active-success rounded h-5px me-2"></div>
																<div class="flex-grow-1 bg-secondary bg-active-success rounded h-5px"></div>
															</div>
															<div class="text-muted">Use 8 ou mais caracteres com uma mistura de letras, números e símbolos.</div>
														</div>
													</div>
													<div class="col-12 col-lg-6">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Permissões</label>
                                                        <select class="form-select form-select-solid" name="role" data-control="select2" data-placeholder="Selecione a Permissão do Utilizador">
                                                            <option></option>
                                                                <option value="Admin">Administrador</option>
																<option value="Doctor">Médico</option>
																<option value="Patient">Utente</option>
                                                        </select>
                                                    </div>

												</div>

											</div>
											<!--end::Card body-->
											<!--begin::Actions-->
											<div class="card-footer d-flex justify-content-end py-6 px-9">
												<button type="reset" class="btn btn-light btn-active-light-primary me-2">Cancelar</button>
												<button type="submit" class="btn btn-primary" id="kt_account_profile_details_submit">Criar</button>
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
		const options = {
			minLength: 8,
			checkUppercase: true,
			checkLowercase: true,
			checkDigit: true,
			checkChar: true,
			scoreHighlightClass: "active"
		};
		var passwordMeterElement = document.querySelector(`#form-add-user .password-meter`);
		var passwordMeter = new KTPasswordMeter(passwordMeterElement, options);
		passwordMeter.check();


		document.addEventListener("DOMContentLoaded", function() {
			const form = document.getElementById("form-add-user");
			form.addEventListener("submit", insertUser);

			const api_url = "http://localhost:3000/api/";
			const path = "users/";

			function insertUser() {
				event.preventDefault();

				var form = document.getElementById("form-add-user");

				const formData = {
					username: form.username.value,
					email: form.email.value,
					password: form.password.value,
					role: form.role.value,
				};


				fetch(api_url + path + "insert", {
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