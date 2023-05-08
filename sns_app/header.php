<!--begin::Header-->
<div id="kt_app_header" class="app-header" data-kt-sticky="true" data-kt-sticky-activate="{default: false, lg: true}" data-kt-sticky-name="app-header-sticky" data-kt-sticky-offset="{default: false, lg: '300px'}">
    <!--begin::Header container-->
    <div class="app-container container-xxl d-flex align-items-stretch justify-content-between" id="kt_app_header_container">
        <!--begin::Header mobile toggle-->
        <div class="d-flex align-items-center d-lg-none ms-n2 me-2" title="Show sidebar menu">
            <div class="btn btn-icon btn-color-gray-600 btn-active-color-primary w-35px h-35px" id="kt_app_header_menu_toggle">
                <i class="ki-outline ki-abstract-14 fs-2"></i>
            </div>
        </div>
        <!--end::Header mobile toggle-->
        <!--begin::Logo-->
        <div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0 me-lg-15">
            <a href="<?php $_SERVER["DOCUMENT_ROOT"] . "/index.php" ?>">
                <img alt="Logo" src="<?php echo $link_home?>assets/media/uploads/logo.svg" class="h-10px d-lg-none" />
                <img alt="Logo" src="<?php echo $link_home?>assets/media/uploads/logo.svg" class="h-30px d-none d-lg-inline app-sidebar-logo-default theme-light-show" />
            </a>
        </div>
        <!--end::Logo-->
        <!--begin::Header wrapper-->
        <div class="d-flex align-items-stretch justify-content-between flex-lg-grow-1" id="kt_app_header_wrapper">
            <!--begin::Menu wrapper-->
            <div class="app-header-menu app-header-mobile-drawer align-items-stretch" data-kt-drawer="true" data-kt-drawer-name="app-header-menu" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="250px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_header_menu_toggle" data-kt-swapper="true" data-kt-swapper-mode="{default: 'append', lg: 'prepend'}" data-kt-swapper-parent="{default: '#kt_app_body', lg: '#kt_app_header_wrapper'}">
                <!--begin::Menu-->
                <div class="menu menu-rounded menu-active-bg menu-state-primary menu-column menu-lg-row menu-title-gray-700 menu-icon-gray-500 menu-arrow-gray-500 menu-bullet-gray-500 my-5 my-lg-0 align-items-stretch fw-semibold px-2 px-lg-0" id="kt_app_header_menu" data-kt-menu="true">
                    <!--begin:Menu item-->
                    <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                        <!--begin:Menu link-->
                        <span class="menu-link">
                            <span class="menu-title">Dashboards</span>
                            <span class="menu-arrow d-lg-none"></span>
                        </span>
                        <!--end:Menu link-->
                        <!--begin:Menu sub-->
                        <div class="menu-sub menu-sub-lg-down-accordion menu-sub-lg-dropdown p-0 w-100 w-lg-700px">
                            <!--begin:Dashboards menu-->
                            <div class="menu-state-bg menu-extended overflow-hidden overflow-lg-visible" data-kt-menu-dismiss="true">
                                <!--begin:Row-->
                                <div class="row">
                                    <!--begin:Col-->
                                    <div class="col-lg-12 mb-3 mb-lg-0 py-3 px-3 py-lg-6 px-lg-6">
                                        <!--begin:Row-->
                                        <div class="row">
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/index.html" class="menu-link active">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-element-11 text-primary fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">Default</span>
                                                            <span class="fs-7 fw-semibold text-muted">Reports & statistics</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/ecommerce.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-basket text-danger fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">eCommerce</span>
                                                            <span class="fs-7 fw-semibold text-muted">Sales reports</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/projects.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-abstract-44 text-info fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">Projects</span>
                                                            <span class="fs-7 fw-semibold text-muted">Tasts, graphs & charts</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/online-courses.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-color-swatch text-success fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">Online Courses</span>
                                                            <span class="fs-7 fw-semibold text-muted">Student progress</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/marketing.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-chart-simple text-dark fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">Marketing</span>
                                                            <span class="fs-7 fw-semibold text-muted">Campaings & conversions</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/bidding.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-switch text-warning fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">Bidding</span>
                                                            <span class="fs-7 fw-semibold text-muted">Campaings & conversions</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/pos.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-abstract-42 text-danger fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">POS System</span>
                                                            <span class="fs-7 fw-semibold text-muted">Campaings & conversions</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                            <!--begin:Col-->
                                            <div class="col-lg-6 mb-3">
                                                <!--begin:Menu item-->
                                                <div class="menu-item p-0 m-0">
                                                    <!--begin:Menu link-->
                                                    <a href="../../demo30/dist/dashboards/call-center.html" class="menu-link">
                                                        <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                            <i class="ki-outline ki-call text-primary fs-1"></i>
                                                        </span>
                                                        <span class="d-flex flex-column">
                                                            <span class="fs-6 fw-bold text-gray-800">Call Center</span>
                                                            <span class="fs-7 fw-semibold text-muted">Campaings & conversions</span>
                                                        </span>
                                                    </a>
                                                    <!--end:Menu link-->
                                                </div>
                                                <!--end:Menu item-->
                                            </div>
                                            <!--end:Col-->
                                        </div>
                                    </div>
                                    <!--end:Col-->

                                </div>
                                <!--end:Row-->
                            </div>
                            <!--end:Dashboards menu-->
                        </div>
                        <!--end:Menu sub-->
                    </div>
                    <!--end:Menu item-->

                </div>
                <!--end::Menu-->
            </div>
            <!--end::Menu wrapper-->
            <!--begin::Navbar-->
            <div class="app-navbar flex-shrink-0">
                <!--begin::Search-->
                <div class="d-flex align-items-center align-items-stretch mx-4">

                </div>
                <!--end::Search-->

                <!--begin::Chat-->
                <div class="app-navbar-item ms-1 ms-lg-5">
                    <!--begin::Menu wrapper-->
                    <div class="btn btn-icon btn-custom btn-color-gray-600 btn-active-light btn-active-color-primary w-35px h-35px w-md-40px h-md-40px position-relative" id="kt_drawer_chat_toggle">
                        <i class="ki-outline ki-notification-on fs-1"></i>
                    </div>
                    <!--end::Menu wrapper-->
                </div>
                <!--end::Chat-->
                <!--begin::User menu-->
                <div class="app-navbar-item ms-3 ms-lg-5" id="kt_header_user_menu_toggle">
                    <!--begin::Menu wrapper-->
                    <div class="cursor-pointer symbol symbol-35px symbol-md-45px" data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">
                        <img class="symbol symbol-circle symbol-35px symbol-md-45px" src="<?php echo $_SESSION["avatar_path"]?>" alt="user" />
                    </div>
                    <!--begin::User account menu-->
                    <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold py-4 fs-6 w-300px" data-kt-menu="true">
                        <!--begin::Menu item-->
                        <div class="menu-item px-3">
                            <div class="menu-content d-flex align-items-center px-3">
                                <!--begin::Avatar-->
                                <div class="symbol symbol-50px me-5">
                                    <img alt="Logo" src="<?php echo $_SESSION["avatar_path"]?>" />
                                </div>
                                <!--end::Avatar-->
                                <!--begin::Username-->
                                <div class="d-flex flex-column">
                                    <div class="d-flex align-items-center">
                                        <span class="badge badge-light-success fw-bold fs-8 px-2 py-1 mb-1">Administrador</span>
                                    </div>
                                    <div class="fw-bold d-flex align-items-center fs-5"><?php echo $_SESSION["name"]; ?></div>
                                    <a href="#" class="fw-semibold text-muted text-hover-primary fs-7"><?php echo $_SESSION["email"]; ?></a>
                                </div>
                                <!--end::Username-->
                            </div>
                        </div>
                        <!--end::Menu item-->
                        <!--begin::Menu separator-->
                        <div class="separator my-2"></div>
                        <!--end::Menu separator-->
                        <!--begin::Menu item-->
                        <div class="menu-item px-5">
                            <a href="<?php echo $link_home?>profile" class="menu-link px-5">Meu Perfil</a>
                        </div>
                        <!--end::Menu item-->

                        <!--begin::Menu separator-->
                        <div class="separator my-2"></div>
                        <!--end::Menu separator-->

                        <!--begin::Menu item-->
                        <div class="menu-item px-5">
                            <a href="<?php echo $link_home ?>pages/auth/logout" class="menu-link px-5">Terminar Sessão</a>
                        </div>
                        <!--end::Menu item-->
                    </div>
                    <!--end::User account menu-->
                    <!--end::Menu wrapper-->
                </div>
                <!--end::User menu-->
                <!--begin::Header menu toggle-->
                <!--end::Header menu toggle-->
            </div>
            <!--end::Navbar-->
        </div>
        <!--end::Header wrapper-->
    </div>
    <!--end::Header container-->
</div>
<!--end::Header-->