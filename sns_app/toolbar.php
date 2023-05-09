<!--begin::Toolbar-->
<div id="kt_app_toolbar" class="app-toolbar py-6">
    <!--begin::Toolbar container-->
    <div id="kt_app_toolbar_container" class="app-container container-xxl d-flex align-items-start">
        <!--begin::Toolbar container-->
        <div class="d-flex flex-column flex-row-fluid">
            <!--begin::Toolbar wrapper-->
            <div class="d-flex align-items-center pt-1">
                <!--begin::Breadcrumb-->
                <ul class="breadcrumb breadcrumb-separatorless fw-semibold">
                    <!--begin::Item-->
                    <li class="breadcrumb-item text-white fw-bold lh-1">
                        <a href="<?php echo $link_home ?>index" class="text-white">
                            <i class="ki-outline ki-home text-white fs-3"></i>
                        </a>
                    </li>
                    <!--end::Item-->
                    <!--begin::Item-->
                    <li class="breadcrumb-item">
                        <i class="ki-outline ki-right fs-4 text-white mx-n1"></i>
                    </li>
                    <!--end::Item-->
                    <!--begin::Item-->
                    <li class="breadcrumb-item text-white fw-bold lh-1">Dashboards</li>
                    <!--end::Item-->
                </ul>
                <!--end::Breadcrumb-->
            </div>
            <!--end::Toolbar wrapper=-->
            <!--begin::Toolbar wrapper=-->
            <div class="d-flex flex-stack flex-wrap flex-lg-nowrap gap-4 gap-lg-10 pt-6 pb-18 py-lg-13">
                <!--begin::Page title-->
                <div class="page-title d-flex align-items-center me-3">
                    <img alt="Logo" src="<?php echo $link_home?>assets/media/svg/misc/layer.svg" class="h-60px me-5" />
                    <!--begin::Title-->
                    <h1 class="page-heading d-flex text-white fw-bolder fs-2 flex-column justify-content-center my-0"><?php echo isset($page_name) ? $page_name : "SNS 24" ?>
                        <!--begin::Description-->
                        <span class="page-desc text-white opacity-50 fs-6 fw-bold pt-4">Serviços Digitais SNS 24</span>
                        <!--end::Description-->
                    </h1>
                    <!--end::Title-->
                </div>
                <!--end::Page title-->
                <!--begin::Items-->
                <div class="d-flex gap-4 gap-lg-13">
                    <!--begin::Item-->
                    <div class="d-flex flex-column">
                        <!--begin::Number-->
                        <span class="text-white fw-bold fs-3 mb-1">808 24 24 24</span>
                        <!--end::Number-->
                        <!--begin::Section-->
                        <div class="text-white fw-bold">Contacte</div>
                        <!--end::Section-->
                    </div>
                    <!--end::Item-->
                    <!--begin::Item-->
                    <!-- <div class="d-flex flex-column">
                        <span class="text-white fw-bold fs-3 mb-1">$1,748.03</span>
                        <div class="text-white opacity-50 fw-bold">Today Spending</div>
                    </div> -->
                    <!--end::Item-->
                    <!--begin::Item-->
                    <!-- <div class="d-flex flex-column">
                        <span class="text-white fw-bold fs-3 mb-1">3.8%</span>
                        <div class="text-white opacity-50 fw-bold">Overall Share</div>
                    </div> -->
                    <!--end::Item-->
                    <!--begin::Item-->
                    <!-- <div class="d-flex flex-column">
                        <span class="text-white fw-bold fs-3 mb-1">-7.4%</span>
                        <div class="text-white opacity-50 fw-bold">7 Days</div>
                    </div> -->
                    <!--end::Item-->
                </div>
                <!--end::Items-->
            </div>
            <!--end::Toolbar wrapper=-->
        </div>
        <!--end::Toolbar container=-->
    </div>
    <!--end::Toolbar container-->
</div>
<!--end::Toolbar-->