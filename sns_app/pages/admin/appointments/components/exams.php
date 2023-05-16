<?php
$data = ["hashed_id_appointment" => $id_appointment];
$exams_info = $api->post("exams/prescribed", $data, null);

$exams_info = $exams_info["response"]["data"];
?>

<div class="tab-pan fade show active" id="appointment_tab_1">
    <div class="card pt-4 mb-6 mb-xl-9">
        <div class="card-header border-0">
            <div class="card-title">
                <h2>Exames Prescritos</h2>
            </div>
        </div>
        <div class="card-body py-0">
            <div class="table-responsive">
                <table class="table align-middle table-row-dashed fw-semibold text-gray-600 fs-6 gy-5" id="kt_table_customers_logs">
                    <tbody>
                        <thead class="border-bottom border-gray-200 fs-7 fw-bold">
                            <tr class="text-start text-muted text-uppercase gs-0">
                                <th class="min-w-150px sorting">Nome</th>
                                <th class="min-w-150px sorting">Pedido a:</th>
                                <th class="min-w-80px sorting">Válido até:</th>
                                <th class="min-w-80px sorting">Estado</th>
                            </tr>
                        </thead>
                        <?php foreach ($exams_info as $key => $value) { ?>
                            <tr>
                                <td><?php echo isset($value["exam_name"]) ? $value["exam_name"] : "N/A" ?></td>
                                <td><?php echo (new DateTime($value["requisition_date"]))->format("d/m/Y"); ?></td>
                                <td><?php echo (new DateTime($value["expiration_date"]))->format("d/m/Y"); ?></td>
                                <td><?php
                                    if ($value["prescribed_exam_status"] === 0) {
                                        echo "Prescrito";
                                    } else if ($value["prescribed_exam_status"] === 1) {
                                        echo "Realizado a: " . ' ' . (new DateTime($value["sheduled_date"]))->format("d/m/Y");;
                                    } else if ($value["prescribed_exam_status"] === 2) {
                                        echo "Cancelado";
                                    } else {
                                        echo "N/A";
                                    }
                                    ?></td>
                            </tr>
                        <?php } ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>