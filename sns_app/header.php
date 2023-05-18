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
            <a href="<?php $_SERVER["DOCUMENT_ROOT"] . "/index" ?>">
                <img alt="Logo" src="<?php echo $link_home ?>assets/media/uploads/logo.svg" class="h-10px d-lg-none" />
                <img alt="Logo" src="<?php echo $link_home ?>assets/media/uploads/logo.svg" class="h-30px d-none d-lg-inline app-sidebar-logo-default theme-light-show" />
            </a>
        </div>
        <!--end::Logo-->
        <!--begin::Header wrapper-->
        <div class="d-flex align-items-stretch justify-content-between flex-lg-grow-1" id="kt_app_header_wrapper">

            <?php if ($_SESSION["active_role"] === "Admin") { ?>
                <!--Admin NavBar-->
                <div class="app-header-menu app-header-mobile-drawer align-items-stretch" data-kt-drawer="true" data-kt-drawer-name="app-header-menu" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="250px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_header_menu_toggle" data-kt-swapper="true" data-kt-swapper-mode="{default: 'append', lg: 'prepend'}" data-kt-swapper-parent="{default: '#kt_app_body', lg: '#kt_app_header_wrapper'}">


                    <div class="menu menu-rounded menu-active-bg menu-state-primary menu-column menu-lg-row menu-title-gray-700 menu-icon-gray-500 menu-arrow-gray-500 menu-bullet-gray-500 my-5 my-lg-0 align-items-stretch fw-semibold px-2 px-lg-0" id="kt_app_header_menu" data-kt-menu="true">

                        <!-- Agenda -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/admin/index"><span class="menu-title">Agenda</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                            <!--end:Menu link-->
                        </div>

                        <!-- Utilizadores -->
                        <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <span class="menu-title">Utilizadores</span>
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
                                            <div class="row">
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-profile-user text-primary fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Utlizadores</span>
                                                                <span class="fs-7 fw-semibold text-muted">Lista de Todos os Utlizadores</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/disabled-list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-profile-user text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Utilizadores Desativados</span>
                                                                <span class="fs-7 fw-semibold text-muted">Todos os Utlizadores Desativados</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar - Utilizadores</span>
                                                                <span class="fs-7 fw-semibold text-muted">Administradores, Médico e Utentes</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <!-- <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-lock text-info fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Gerir Permissões</span>
                                                                <span class="fs-7 fw-semibold text-muted">Gerir as Permissões dos Utilizadores</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div> -->
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

                        <!-- Consultas -->
                        <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <span class="menu-title">Consultas</span>
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
                                            <div class="row">
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/appointments/list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-calendar-add text-primary fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Todas as Consultas</span>
                                                                <span class="fs-7 fw-semibold text-muted">Lista de Todas as Consultas</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/appointments/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar Consulta</span>
                                                                <span class="fs-7 fw-semibold text-muted">Adicionar uma Nova Consulta</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <!-- <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/disabled-list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-profile-user text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Utilizadores Desativados</span>
                                                                <span class="fs-7 fw-semibold text-muted">Todos os Utlizadores Desativados</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div> -->
                                                <!-- <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar - Utilizadores</span>
                                                                <span class="fs-7 fw-semibold text-muted">Administradores, Médico e Utentes</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div> -->
                                                <!-- <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/users/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-lock text-info fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Gerir Permissões</span>
                                                                <span class="fs-7 fw-semibold text-muted">Gerir as Permissões dos Utilizadores</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div> -->
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

                        <!-- Unidades de Saúde -->
                        <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <span class="menu-title">Unidades Saúde</span>
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
                                            <div class="row">
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/health-units/list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-bank text-primary fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Unidades de Saúde</span>
                                                                <span class="fs-7 fw-semibold text-muted">Listar Unidades de Saúde</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/health-units/disabled-list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-bank text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Unidades de Saúde Desativadas</span>
                                                                <span class="fs-7 fw-semibold text-muted">Listar Unidades de Saúde Desativadas</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/health-units/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar - Unidades de Saúde</span>
                                                                <span class="fs-7 fw-semibold text-muted">Adicionar Unidades de Saúde</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
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

                        <!-- Exames -->
                        <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <span class="menu-title">Exames</span>
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
                                            <div class="row">
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/exams/list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-document text-primary fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Prescrição de Exames</span>
                                                                <span class="fs-7 fw-semibold text-muted">Listar as Prescrições dos Exames</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/exams/disabled-list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-document text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Prescrição de Exames Desativadas</span>
                                                                <span class="fs-7 fw-semibold text-muted">Prescrições dos Exames Desativadas</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/exams/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar - Prescrição de Exame</span>
                                                                <span class="fs-7 fw-semibold text-muted">Adicionar Prescrição de Exame</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
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

                        <!-- Vacines -->
                        <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <span class="menu-title">Vacinas</span>
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
                                            <div class="row">
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/vaccines/list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-syringe text-primary fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Prescrição de Vacinas</span>
                                                                <span class="fs-7 fw-semibold text-muted">Listar as Prescrições das Vacinas</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/vaccines/disabled-list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-syringe text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Prescrição de Vacinas Desativadas</span>
                                                                <span class="fs-7 fw-semibold text-muted">Prescrições das Vacinas Desativadas</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/vaccines/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar - Prescrição de Vacina</span>
                                                                <span class="fs-7 fw-semibold text-muted">Adicionar Prescrição de Vacina</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
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

                        <!-- Medication -->
                        <div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" data-kt-menu-offset="-50,0" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
                            <!--begin:Menu link-->
                            <span class="menu-link">
                                <span class="menu-title">Medicação</span>
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
                                            <div class="row">
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/medications/list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-capsule text-primary fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Prescrição de Medicação</span>
                                                                <span class="fs-7 fw-semibold text-muted">Listar as Prescrições das Medicação</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/medications/disabled-list" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-capsule text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Prescrição de Medicação Desativadas</span>
                                                                <span class="fs-7 fw-semibold text-muted">Prescrições das Medicação Desativadas</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 mb-3">
                                                    <div class="menu-item p-0 m-0">
                                                        <a href="<?php echo $link_home; ?>pages/admin/medications/add" class="menu-link">
                                                            <span class="menu-custom-icon d-flex flex-center flex-shrink-0 rounded w-40px h-40px me-3">
                                                                <i class="ki-outline ki-plus-square text-danger fs-1"></i>
                                                            </span>
                                                            <span class="d-flex flex-column">
                                                                <span class="fs-6 fw-bold text-gray-800">Adicionar - Prescrição de Medicação</span>
                                                                <span class="fs-7 fw-semibold text-muted">Adicionar Prescrição de Medicação</span>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
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


                    </div>

                </div>
                <!--Admin NavBar-->
            <?php } ?>

            <?php if ($_SESSION["active_role"] === "Doctor") { ?>
                <!-- Doctor NavBar -->
                <div class="app-header-menu app-header-mobile-drawer align-items-stretch" data-kt-drawer="true" data-kt-drawer-name="app-header-menu" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="250px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_header_menu_toggle" data-kt-swapper="true" data-kt-swapper-mode="{default: 'append', lg: 'prepend'}" data-kt-swapper-parent="{default: '#kt_app_body', lg: '#kt_app_header_wrapper'}">
                    <div class="menu menu-rounded menu-active-bg menu-state-primary menu-column menu-lg-row menu-title-gray-700 menu-icon-gray-500 menu-arrow-gray-500 menu-bullet-gray-500 my-5 my-lg-0 align-items-stretch fw-semibold px-2 px-lg-0" id="kt_app_header_menu" data-kt-menu="true">

                        <!-- Agenda -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/doctor/index"><span class="menu-title">Agenda</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                        <!-- Consultas -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/doctor/appointments/list"><span class="menu-title">Consultas</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                    </div>

                </div>

            <?php } ?>

            <?php if ($_SESSION["active_role"] === "Patient") { ?>
                <!-- Patient NavBar -->
                <div class="app-header-menu app-header-mobile-drawer align-items-stretch" data-kt-drawer="true" data-kt-drawer-name="app-header-menu" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="250px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_header_menu_toggle" data-kt-swapper="true" data-kt-swapper-mode="{default: 'append', lg: 'prepend'}" data-kt-swapper-parent="{default: '#kt_app_body', lg: '#kt_app_header_wrapper'}">
                    <div class="menu menu-rounded menu-active-bg menu-state-primary menu-column menu-lg-row menu-title-gray-700 menu-icon-gray-500 menu-arrow-gray-500 menu-bullet-gray-500 my-5 my-lg-0 align-items-stretch fw-semibold px-2 px-lg-0" id="kt_app_header_menu" data-kt-menu="true">

                        <!-- Agenda -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/patient/schedule/index"><span class="menu-title">Agenda</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                        <!-- Consultas -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/patient/appointments/list"><span class="menu-title">Consultas</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                        <!-- Medicação -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/patient/medications/list"><span class="menu-title">Medicação</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                        <!-- Exames -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/patient/exams/list"><span class="menu-title">Exames</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                        <!-- Vacinas -->
                        <div class="menu-item here show menu-here-bg me-0 me-lg-2">
                            <span class="menu-link">
                                <a href="<?php echo $link_home; ?>pages/patient/vaccines/list"><span class="menu-title">Vacinas</span></a>
                                <span class="menu-arrow d-lg-none"></span>
                            </span>
                        </div>

                    </div>
                </div>
            <?php } ?>

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
                        <img class="symbol symbol-circle symbol-35px symbol-md-45px" src="<?php echo $_SESSION["avatar_path"] ?>" alt="user" />
                    </div>
                    <!--begin::User account menu-->
                    <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold py-4 fs-6 w-300px" data-kt-menu="true">
                        <!--begin::Menu item-->
                        <div class="menu-item px-3">
                            <div class="menu-content d-flex align-items-center px-3">
                                <!--begin::Avatar-->
                                <div class="symbol symbol-50px me-5">
                                    <img alt="Logo" src="<?php echo $_SESSION["avatar_path"] ?>" />
                                </div>
                                <!--end::Avatar-->
                                <!--begin::Username-->
                                <div class="d-flex flex-column">
                                    <div class="d-flex align-items-center">
                                        <?php if ($_SESSION["active_role"] == "Admin") {
                                            echo '<span class="badge badge-light-success fw-bold fs-8 px-2 py-1 mb-1">Administrador</span>';
                                        } else if ($_SESSION["active_role"] == "Doctor") {
                                            echo '<span class="badge badge-light-warning fw-bold fs-8 px-2 py-1 mb-1">Médico</span>';
                                        } else if ($_SESSION["active_role"] == "Patient") {
                                            echo '<span class="badge badge-light-info fw-bold fs-8 px-2 py-1 mb-1">Utente</span>';
                                        }
                                        ?>
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
                            <a href="<?php echo $link_home ?>profile" class="menu-link px-5">Meu Perfil</a>
                        </div>
                        <!--end::Menu item-->

                        <!--begin::Menu separator-->
                        <div class="separator my-2"></div>
                        <!--end::Menu separator-->

                        <?php if(count($_SESSION['roles']) > 1){ ?>
                            <!--begin::Menu item-->
                            <div class="menu-item px-5">
                                <a href="<?php echo $link_home ?>" class="menu-link px-5">Trocar de Conta</a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu separator-->
                            <div class="separator my-2"></div>
                            <!--end::Menu separator-->
                        <?php } ?>
                        
                        
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