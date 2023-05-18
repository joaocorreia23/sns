<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$api = new Api();
$user_info = $api->fetch("users/", null, $id_user);
$user_info_data = $user_info["response"];

$countries = $api->fetch("countries/", null, null);
$countries_list = $countries["response"];
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

                                <?php
                                if ($user_info["status"] === false) {
                                    echo '<script>toastr.error("Erro ao obter Dados do Utilizador!", "Erro!");;
                                    setTimeout(() => {
                                        window.location.href = "404";
                                      }, 650);
                                    </script>';
                                    exit;
                                } else if ($user_info["status"] === true) {
                                    echo '<script>toastr.success("Dados do Utilizador Obtidos com Sucesso!", "Sucesso!");</script>';
                                }
                                ?>

                                <!--begin::Navbar-->
                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-body pt-9 pb-0">
                                        <!--begin::Details-->
                                        <div class="d-flex flex-wrap flex-sm-nowrap">
                                            <!--begin: Pic-->
                                            <div class="me-7 mb-4">
                                                <div class="symbol symbol-100px symbol-lg-160px symbol-fixed position-relative">
                                                    <img src="<?php echo $user_info_data["avatar_path"] ?>" alt="image">
                                                </div>
                                            </div>
                                            <!--end::Pic-->

                                            <!--begin::Info-->
                                            <div class="flex-grow-1">
                                                <!--begin::Title-->
                                                <div class="d-flex justify-content-between align-items-start flex-wrap mb-2">
                                                    <!--begin::User-->
                                                    <div class="d-flex flex-column">
                                                        <!--begin::Name-->
                                                        <div class="d-flex align-items-center mb-2">
                                                            <a class="text-gray-900 text-hover-primary fs-2 fw-bold me-1"><?php echo $user_info_data["first_name"] . ' ' . $user_info_data["last_name"] ?></a>
                                                        </div>
                                                        <!--end::Name-->

                                                        <!--begin::Info-->
                                                        <div class="d-flex flex-wrap fw-semibold fs-6 mb-4 pe-2">
                                                            <a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary me-5 mb-2">
                                                                <i class="ki-outline ki-sms fs-4 me-1"></i><?php echo $user_info_data["email"] ?></a>
                                                            <a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary me-5 mb-2">
                                                                <i class="ki-outline ki-phone fs-4 me-1"></i><?php echo $user_info_data["phone_number"] ?></a>
                                                            <a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary mb-2">
                                                                <i class="ki-outline ki-information-2 fs-4 me-1"></i>
                                                                <?php echo (new DateTime($user_info_data["created_at"]))->format("d/m/Y - H:i"); ?>
                                                        </div>
                                                        <span class="badge badge-success me-2">Ativo</span>
                                                        <span class="badge badge-warning me-2"><?php echo $user_info_data["gender"] ?></span>
                                                        <!--end::Info-->
                                                    </div>
                                                    <!--end::User-->

                                                </div>
                                                <!--end::Title-->

                                            </div>
                                            <!--end::Info-->
                                        </div>
                                        <!--end::Details-->

                                        <!--begin::Navs-->
                                        <ul class="nav nav-stretch nav-line-tabs nav-line-tabs-2x border-transparent fs-5 fw-bold">
                                            <!--begin::Nav item-->
                                            <li class="nav-item mt-2">
                                                <a class="nav-link text-active-primary ms-0 me-10 py-5 active">
                                                    Editar Perfil
                                                </a>
                                            </li>
                                            <!--end::Nav item-->
                                        </ul>
                                        <!--begin::Navs-->
                                    </div>
                                </div>
                                <!--end::Navbar-->
                                <div class="card mb-5 mb-xl-10">
                                    <!--begin::Card header-->
                                    <div class="card-header border-0 cursor-pointer" role="button" data-bs-toggle="collapse" data-bs-target="#kt_account_profile_details" aria-expanded="true" aria-controls="kt_account_profile_details">
                                        <!--begin::Card title-->
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">Detalhes do Perfil</h3>
                                        </div>
                                        <!--end::Card title-->
                                    </div>
                                    <!--begin::Card header-->
                                    <!--begin::Content-->
                                    <div id="kt_account_settings_profile_details" class="collapse show">
                                        <!--begin::Form-->
                                        <form id="form-update-user-info" class="form fv-plugins-bootstrap5 fv-plugins-framework" novalidate="novalidate">
                                            <!--begin::Card body-->
                                            <div class="card-body border-top p-9">

                                                <div class="row mb-6">
                                                    <label class="col-form-label fw-semibold fs-6">Avatar</label>
                                                    <div class="">
                                                        <div class="image-input image-input-outline" data-kt-image-input="true" style="background-image: url('assets/media/svg/avatars/blank.svg')">
                                                            <div class="image-input-wrapper w-125px h-125px" style="background-image: url(<?php echo $user_info_data["avatar_path"] ?>)"></div>
                                                            <label class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-body shadow" data-kt-image-input-action="change" data-bs-toggle="tooltip" aria-label="Change avatar" data-bs-original-title="Change avatar" data-kt-initialized="1">
                                                                <i class="ki-outline ki-pencil fs-7"></i>
                                                                <input type="file" name="avatar_path" accept=".png, .jpg, .jpeg">
                                                                <input type="hidden" name="avatar_remove">
                                                            </label>
                                                            <span class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-body shadow" data-kt-image-input-action="cancel" data-bs-toggle="tooltip" aria-label="Cancel avatar" data-bs-original-title="Cancel avatar" data-kt-initialized="1">
                                                                <i class="ki-outline ki-cross fs-2"></i>
                                                            </span>
                                                            <span class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-body shadow" data-kt-image-input-action="remove" data-bs-toggle="tooltip" aria-label="Remove avatar" data-bs-original-title="Remove avatar" data-kt-initialized="1">
                                                                <i class="ki-outline ki-cross fs-2"></i>
                                                            </span>
                                                        </div>
                                                        <div class="form-text">Tipos de Ficheiros Permitidos: png, jpg, jpeg.</div>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <label class="col-form-label required fw-semibold fs-6">Nome Completo</label>
                                                    <div class="">
                                                        <div class="row">
                                                            <div class="col-lg-6 fv-row fv-plugins-icon-container">
                                                                <input type="text" name="first_name" class="form-control form-control-lg form-control-solid mb-3 mb-lg-0" placeholder="Primeiro Nome" value="<?php echo $user_info_data["first_name"] ?>">
                                                                <div class="fv-plugins-message-container invalid-feedback"></div>
                                                            </div>
                                                            <div class="col-lg-6 fv-row fv-plugins-icon-container">
                                                                <input type="text" name="last_name" class="form-control form-control-lg form-control-solid" placeholder="Último Nome" value="<?php echo $user_info_data["last_name"] ?>">
                                                                <div class="fv-plugins-message-container invalid-feedback"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Data de Nascimento</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input class="form-control form-control-solid" placeholder="Selecione uma Data" id="birth_date" />
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Género</label>
                                                        <select class="form-select form-select-solid" name="gender" data-control="select2" data-hide-search="true" data-placeholder="Selecione um Género">
                                                            <option></option>
                                                            <option <?php if ($user_info_data["gender"] === "Masculino") echo "selected" ?> value="Masculino">Masculino</option>
                                                            <option <?php if ($user_info_data["gender"] === "Feminino") echo "selected" ?> value="Feminino">Feminino</option>
                                                            <option <?php if ($user_info_data["gender"] === "Outro") echo "selected" ?> value="Outro">Outro</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Número Identificação Fiscal</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="tax_number" class="form-control form-control-lg form-control-solid" placeholder="NIF" value="<?php echo $user_info_data["tax_number"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-2">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Contacto Telefónico</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="phone_number" class="form-control form-control-lg form-control-solid" placeholder="Número para Contacto" value="<?php echo $user_info_data["phone_number"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Contacto Email</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="email" name="contact_email" class="form-control form-control-lg form-control-solid" placeholder="Email para Contacto" value="<?php echo $user_info_data["contact_email"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Nacionalidade</label>
                                                        <select class="form-select form-select-solid" name="nationality" data-control="select2" data-placeholder="Selecione uma Nacionalidade">
                                                            <option></option>
                                                            <?php foreach ($countries_list as $key => $value) { ?>
                                                                <option <?php if ($value["id_country"] == $user_info_data["nationality"]) echo "selected" ?> value="<?php echo $value["id_country"] ?>"><?php echo $value["country_name"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Naturalidade</label>
                                                        <select class="form-select form-select-solid" name="id_country" data-control="select2" data-placeholder="Selecione uma Naturalidade">
                                                            <option></option>
                                                            <?php foreach ($countries_list as $key => $value) { ?>
                                                                <option <?php if ($value["id_country"] == $user_info_data["id_country"]) echo "selected" ?> value="<?php echo $value["id_country"] ?>"><?php echo $value["country_name"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Distrito</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="district_name" class="form-control form-control-lg form-control-solid" placeholder="Distrito" value="<?php echo $user_info_data["district_name"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Concelho</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="county_name" class="form-control form-control-lg form-control-solid" placeholder="Concelho" value="<?php echo $user_info_data["county_name"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-6">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Morada</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="address" class="form-control form-control-lg form-control-solid" placeholder="Morada" value="<?php echo $user_info_data["address"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Código-Postal</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="zipcode" class="form-control form-control-lg form-control-solid" placeholder="Código-Postal" value="<?php echo $user_info_data["zipcode"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Número da Porta</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="door_number" class="form-control form-control-lg form-control-solid" placeholder="Número da Porta" value="<?php echo $user_info_data["door_number"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Andar</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="floor" class="form-control form-control-lg form-control-solid" placeholder="Andar" value="<?php echo $user_info_data["floor"] ?>">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>


                                            </div>
                                            <?php if($_SESSION['active_role'] === "Patient" || $_SESSION['active_role'] === "Doctor") { ?>
                                                <div class="card-body border-top p-9">
                                                    <div class="row">
                                                        <?php if($_SESSION['active_role'] === "Patient") { ?>
                                                            <div class="col-12 col-lg-4">
                                                                <label class="col-lg-12 col-form-label fw-semibold fs-6">Numero de Utente</label>
                                                                <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                                    <input type="text" name="patient_number" class="form-control form-control-lg form-control-solid" placeholder="Numero de Utente" value="<?php echo $user_info_data["patient_number"] ?>">
                                                                    <div class="fv-plugins-message-container invalid-feedback"></div>
                                                                </div>
                                                            </div>
                                                        <?php } else if($_SESSION['active_role'] === "Doctor") { ?>
                                                            <div class="col-12 col-lg-4">
                                                                <label class="col-lg-12 col-form-label fw-semibold fs-6">Número de Cédula Profissional</label>
                                                                <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                                    <input type="text" name="doctor_number" class="form-control form-control-lg form-control-solid" placeholder="Número de Cédula Profissional" value="<?php echo $user_info_data["doctor_number"] ?>">
                                                                    <div class="fv-plugins-message-container invalid-feedback"></div>
                                                                </div>
                                                            </div>
                                                        <?php } ?>
                                                    </div>
                                                </div>
                                            <?php } ?>
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
        $("#birth_date").flatpickr();

        <?php $birth_date = (new DateTime($user_info_data["bith_date"]))->format("d-m-Y"); ?>
        flatpickr("#birth_date", {
            dateFormat: "Y-m-d",
            locale: "pt",
            allowInput: true,
            defaultDate: ["<?php echo $birth_date ?>"],
            maxDate: "today",
        });

        const inputNif = document.querySelector(`[name="tax_number"]`);
        Inputmask({
            mask: "999999999",
            showMaskOnHover: true,
            showMaskOnFocus: true,
        }).mask(inputNif);

        const inputZipCode = document.querySelector(`[name="zipcode"]`);
        Inputmask({
            mask: "9999-999",
            placeholder: "_",
            showMaskOnHover: true,
            showMaskOnFocus: true,
        }).mask(inputZipCode);
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("form-update-user-info");
            form.addEventListener("submit", updateUserInfo);

            const api_url = "http://localhost:3000/api/";
            const path = "users/";

            function updateUserInfo() {
                event.preventDefault();

                var form = document.getElementById("form-update-user-info");

                const formData = {
                    hashed_id: "<?php echo $id_user ?>",
                    first_name: form.first_name.value,
                    last_name: form.last_name.value,
                    birth_date: form.birth_date.value,
                    gender: form.gender.value,
                    tax_number: form.tax_number.value,
                    phone_number: form.phone_number.value,
                    contact_email: form.contact_email.value,
                    nationality: form.nationality.value,
                    id_country: form.id_country.value,
                    district: form.district_name.value,
                    county: form.county_name.value,
                    address: form.address.value,
                    zip_code: form.zipcode.value,
                    door_number: form.door_number.value,
                    floor: form.floor.value,
                    avatar_path: "assets/media/uploads/ico.png",
                    patient_number: <?php if($_SESSION['active_role'] === "Patient") { echo "form.patient_number.value,"; } else { echo "null,"; } ?>
                    doctor_number: <?php if($_SESSION['active_role'] === "Doctor") { echo "form.doctor_number.value,"; } else { echo "null,"; } ?>
                };


                fetch(api_url + path + "update/info", {
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
                                text: "Dados atualizados com sucesso!",
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
                                    window.location.href = "profile";
                                }
                            });
                        } else {
                            console.log(JSON.stringify(formData)),
                                Swal.fire({
                                    icon: "error",
                                    title: "Ocorreu um Erro!",
                                    text: "Dados em falta ou incorretos! Verifique novamente os dados!",
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
        });
    </script>

</body>

</html>