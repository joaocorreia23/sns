<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>

<body id="kt_body" class="app-blank">
    <!--end::Theme mode setup on page load-->
    <!--begin::Root-->
    <div class="d-flex flex-column flex-root" id="kt_app_root">
        <!--begin::Authentication - Sign-in -->
        <div class="d-flex flex-column flex-lg-row flex-column-fluid">
            <!--begin::Body-->
            <div class="d-flex flex-column flex-lg-row-fluid w-lg-50 p-10 order-2 order-lg-1">
                <!--begin::Form-->
                <div class="d-flex flex-center flex-column flex-lg-row-fluid">
                    <!--begin::Wrapper-->
                    <div class="w-lg-500px p-10">
                        <!--begin::Form-->
                        <form class="form w-100 text-center" novalidate="novalidate" id="login-form">
                            <!--begin::Heading-->
                            <!--begin::Logo-->
                            <a class="mb-0 mb-lg-12">
                                <img alt="Logo" src="<?php echo $link_home ?>/assets/media/uploads/logo_letras.png" class="h-150px mb-20" />
                            </a>
                            <!--end::Logo-->
                            <div class="text-center mb-11">
                                <!--begin::Title-->
                                <h1 class="text-dark fw-bolder mb-3">Entrar na Minha Área</h1>
                                <!--end::Title-->
                                <!--begin::Subtitle-->
                                <div class="text-gray-500 fw-semibold fs-6">Insira as suas Credenciais!</div>
                                <!--end::Subtitle=-->
                            </div>
                            <!--begin::Heading-->
                            <!--begin::Input group=-->
                            <div class="fv-row mb-8">
                                <!--begin::Email-->
                                <input type="text" placeholder="Email" name="email" autocomplete="off" class="form-control bg-transparent" />
                                <!--end::Email-->
                            </div>
                            <!--end::Input group=-->
                            <div class="fv-row mb-3">
                                <!--begin::Password-->
                                <input type="password" placeholder="Palavra-Passe" name="password" autocomplete="off" class="form-control bg-transparent" />
                                <!--end::Password-->
                            </div>
                            <!--end::Input group=-->
                            <!--begin::Wrapper-->
                            <div class="d-flex flex-stack flex-wrap gap-3 fs-base fw-semibold mb-8">
                                <div></div>
                                <!--begin::Link-->
                                <a href="" class="link-primary">Esqueceu-se da Palavra-Passe?</a>
                                <!--end::Link-->
                            </div>
                            <!--end::Wrapper-->
                            <!--begin::Submit button-->
                            <div class="d-grid mb-10">
                                <button type="submit" id="kt_sign_in_submit" class="btn btn-primary">
                                    <!--begin::Indicator label-->
                                    <span class="indicator-label">Entrar</span>
                                    <!--end::Indicator label-->
                                    <!--begin::Indicator progress-->
                                    <span class="indicator-progress">Por Favor Aguarde...
                                        <span class="spinner-border spinner-border-sm align-middle ms-2"></span></span>
                                    <!--end::Indicator progress-->
                                </button>
                            </div>
                            <!--end::Submit button-->
                            <!--begin::Sign up-->
                            <!-- <div class="text-gray-500 text-center fw-semibold fs-6">Not a Member yet?
                                <a href="../../demo30/dist/authentication/layouts/corporate/sign-up.html" class="link-primary">Sign up</a>
                            </div> -->
                            <!--end::Sign up-->
                        </form>
                        <!--end::Form-->
                    </div>
                    <!--end::Wrapper-->
                </div>
                <!--end::Form-->
            </div>
            <!--end::Body-->
            <!--begin::Aside-->
            <div class="d-flex flex-lg-row-fluid w-lg-50 bgi-size-cover bgi-position-center order-1 order-lg-2" style="background-image: url(<?php echo $link_home ?>/assets/media/uploads/fundo_login.jpeg)">
                <!--begin::Content-->
                <div class="d-flex flex-column flex-center py-7 py-lg-15 px-5 px-md-15 w-100">
                    <!--begin::Image-->
                    <img class="d-none d-lg-block mx-auto w-50 w-md-50 mb-10 mb-lg-20" src="<?php echo $link_home ?>/assets/media/uploads/image_login.svg" alt="" />
                    <!--end::Image-->
                    <!--begin::Title-->
                    <h1 class="text-white fs-2qx fw-bolder text-center mb-7">
                        A sua saúde num só sítio
                    </h1> <!--end::Title-->
                    <!--begin::Text-->
                    <div class="text-white fs-base text-center">
                        Já conhece a nossa aplicação SNS 24.<br /> Disponível na <a href="#" class="opacity-75-hover text-primary fw-bold me-1">App Store</a>, <a href="#" class="opacity-75-hover text-primary fw-bold me-1">Google Play</a> e <a href="#" class="opacity-75-hover text-primary fw-bold me-1">Huawei Store</a>.
                    </div>
                    <!--end::Text-->
                </div>
                <!--end::Content-->
            </div>
            <!--end::Aside-->
        </div>
        <!--end::Authentication - Sign-in-->
    </div>
    <!--end::Root-->
    <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/foo.php") ?>

    <script src="<?php echo $link_home ?>api/auth.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("login-form");
            form.addEventListener("submit", handleLogin);
        });
    </script>



</body>

</html>