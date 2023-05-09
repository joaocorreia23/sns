<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php $page_name = "Adicionar Unidade de Saúde" ?>

<?php
$api = new Api();
$types = $api->fetch("health_unit/types", null, null);
$types_list = $types["response"];
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
                                <div class="card mb-5 mb-xl-10">
                                    <!--begin::Card header-->
                                    <div class="card-header border-0 cursor-pointer" role="button" data-bs-toggle="collapse" data-bs-target="#kt_account_profile_details" aria-expanded="true" aria-controls="kt_account_profile_details">
                                        <!--begin::Card title-->
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">Adicionar Nova Unidade de Saúde</h3>
                                        </div>
                                        <!--end::Card title-->
                                    </div>
                                    <!--begin::Card header-->
                                    <!--begin::Content-->
                                    <div id="kt_account_settings_profile_details" class="collapse show">
                                        <!--begin::Form-->
                                        <form id="form-add-health-unit" class="form fv-plugins-bootstrap5 fv-plugins-framework" novalidate="novalidate">
                                            <!--begin::Card body-->
                                            <div class="card-body border-top p-9">

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-6">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Nome</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="name" class="form-control form-control-lg form-control-solid" placeholder="Nome da Unidade de Saúde" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Contacto Telefónico</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="phone_number" class="form-control form-control-lg form-control-solid" placeholder="Número para Contacto" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Contacto Email</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="email" name="email" class="form-control form-control-lg form-control-solid" placeholder="Email para Contacto" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Tipo da Unidade de Saúde</label>
                                                        <select class="form-select form-select-solid" name="type" data-control="select2" data-placeholder="Selecione um Tipo de Unidade">
                                                            <option></option>
                                                            <?php foreach ($types_list as $key => $value) { ?>
                                                                <option value="<?php echo $value["unit_type"] ?>"><?php echo $value["unit_type"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Número Identificação Fiscal</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="tax_number" class="form-control form-control-lg form-control-solid" placeholder="NIF" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">País</label>
                                                        <input type="text" name="id_country" class="form-control form-control-lg form-control-solid" readonly value="Portugal">
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-6">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Morada</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="address" class="form-control form-control-lg form-control-solid" placeholder="Morada" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Distrito</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="district" class="form-control form-control-lg form-control-solid" placeholder="Distrito" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-3">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Concelho</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="county" class="form-control form-control-lg form-control-solid" placeholder="Concelho" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Código-Postal</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="zip_code" class="form-control form-control-lg form-control-solid" placeholder="Código-Postal" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Número da Porta</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="door_number" class="form-control form-control-lg form-control-solid" placeholder="Número da Porta" value="">
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label fw-semibold fs-6">Andar</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input type="text" name="floor" class="form-control form-control-lg form-control-solid" placeholder="Andar" value="">
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
        const inputNif = document.querySelector(`[name="tax_number"]`);
        Inputmask({
            mask: "999999999",
            showMaskOnHover: true,
            showMaskOnFocus: true,
        }).mask(inputNif);

        const inputZipCode = document.querySelector(`[name="zip_code"]`);
        Inputmask({
            mask: "9999-999",
            placeholder: "_",
            showMaskOnHover: true,
            showMaskOnFocus: true,
        }).mask(inputZipCode);
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("form-add-health-unit");
            form.addEventListener("submit", insertHealthUnit);

            const api_url = "http://localhost:3000/api/";
            const path = "health_unit/";

            function insertHealthUnit() {
                event.preventDefault();

                var form = document.getElementById("form-add-health-unit");

                const formData = {
                    name: form.name.value,
                    phone_number: form.phone_number.value,
                    email: form.email.value,
                    type: form.type.value,
                    tax_number: form.tax_number.value,
                    door_number: form.door_number.value,
                    floor: form.floor.value,
                    address: form.address.value,
                    zip_code: form.zip_code.value,
                    county: form.county.value,
                    district: form.district.value,
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
                                text: "Unidade de Saúde adicionada com Sucesso!",
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