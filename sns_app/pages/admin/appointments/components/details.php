<div class="tab-pan fade show active" id="appointment_tab_1">
    <div class="card card-flush py-4 flex-row-fluid position-relative">
        <!--begin::Background-->
        <div class="position-absolute top-0 end-0 bottom-0 opacity-10 d-flex align-items-center me-5">
            <i class="ki-solid ki-bank" style="font-size: 14em"></i>
        </div>
        <!--end::Background-->
        <!--begin::Card header-->
        <div class="card-header">
            <div class="card-title">
                <h2>Informação da Unidade de Saúde</h2>
            </div>
        </div>
        <!--end::Card header-->
        <!--begin::Card body-->
        <div class="card-body pt-0">
            <div class="py-5 fs-7">
                <?php if ($appointment_info["health_unit_type"] === "Hospital Publico") {
                    echo '<span class="badge badge-success px-2 py-2">Hospital Publico</span>';
                } else if ($appointment_info["health_unit_type"] === "Hospital Privado") {
                    echo '<span class="badge badge-danger px-2 py-2">Hospital Privado</span>';
                } else if ($appointment_info["health_unit_type"] === "Clinica Publica") {
                    echo '<span class="badge badge-warning px-2 py-2">Clinica Publica</span>';
                } else if ($appointment_info["health_unit_type"] === "Clinica Privada") {
                    echo '<span class="badge badge-info px-2 py-2">Clinica Privada</span>';
                } else if ($appointment_info["health_unit_type"] === "Centro de Saúde") {
                    echo '<span class="badge badge-dark px-2 py-2">Centro de Saúde</span>';
                } else {
                    echo '<span class="badge badge-secondary px-2 py-2">Outro</span>';
                } ?>
                <div class="fw-bold fs-6 mt-4"><?php echo $appointment_info["health_unit_name"] ?></span></div>
                <div class="mt-5"><span class="fw-bold">Email: </span><?php echo $appointment_info["health_unit_email"] ?></span></div>
                <div class="mt-5"><span class="fw-bold">Telefone: </span><?php echo $appointment_info["health_unit_phone_number"] ?></span></div>
                <div class="mt-5"><span class="fw-bold">NIF: </span><?php echo $appointment_info["health_unit_tax_number"] ?></span></div>
                <div class="mt-5">
                    <span class="fw-bold">Morada: </span>
                    <?php echo $appointment_info["health_unit_address"] ?>
                    <?php echo ' '; ?>
                    <span class="fw-bold">Nº: </span>
                    <?php echo $appointment_info["health_unit_door_number"] ?>
                    <span class="fw-bold">Andar: </span>
                    <?php echo $appointment_info["health_unit_floor"] ?>
                    <br>
                    <?php echo $appointment_info["health_unit_county_name"] ?>
                    <?php echo ' , '; ?>
                    <?php echo $appointment_info["health_unit_district_name"] ?>
                    <span class="fw-bold">Cod. Postal: </span>
                    <?php echo $appointment_info["health_unit_zip_code"] ?>


                </div>
            </div>
        </div>
        <!--end::Card body-->
    </div>


    <div class="card card-flush py-4 flex-row-fluid position-relative mt-4">
        <!--begin::Background-->
        <div class="position-absolute top-0 end-0 bottom-0 opacity-10 d-flex align-items-center me-5">
            <i class="ki-solid ki-user-tick" style="font-size: 14em"></i>
        </div>
        <!--end::Background-->
        <!--begin::Card header-->
        <div class="card-header">
            <div class="card-title">
                <h2>Informação do Médico</h2>
            </div>
        </div>
        <!--end::Card header-->
        <!--begin::Card body-->
        <div class="card-body pt-0">
            <div class="py-5 fs-7">
                <?php if ($appointment_info["doctor_status"] === 1) {
                    echo '<span class="badge badge-success px-2 py-2">Ativo</span>';
                } else if ($appointment_info["doctor_status"] === 0) {
                    echo '<span class="badge badge-danger px-2 py-2">Inativo</span>';
                } else {
                    echo '<span class="badge badge-secondary px-2 py-2">Outro</span>';
                } ?>
                <div class="fw-bold fs-6 mt-4"><?php echo $appointment_info["doctor_first_name"] . ' ' . $appointment_info["doctor_last_name"] ?></span></div>
                <div class="mt-5"><span class="fw-bold">Email: </span><?php echo $appointment_info["doctor_email"] ?></span></div>
                <div class="mt-5"><span class="fw-bold">Telefone: </span><?php echo $appointment_info["doctor_phone_number"] ?></span></div>
                <div class="mt-5"><span class="fw-bold">Cédula: </span><?php echo $appointment_info["doctor_number"] ?></span></div>
            </div>
        </div>
        <!--end::Card body-->
    </div>
</div>