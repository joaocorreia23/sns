<?php
$data = ["hashed_id_appointment" => $id_appointment];
$vaccines_info = $api->post("vaccines/administered", $data, null);

$vaccines_info = $vaccines_info["response"]["data"];
?>

<div class="tab-pan fade show active" id="appointment_tab_1">
    <div class="card pt-4 mb-6 mb-xl-9">
        <div class="card-header border-0">
            <div class="card-title">
                <h2>Vacinas Administradas</h2>
            </div>
        </div>
        <div class="card-body py-0">
            <div class="table-responsive">
                <table class="table align-middle table-row-dashed fw-semibold text-gray-600 fs-6 gy-5" id="kt_table_customers_logs">
                    <tbody>
                        <thead class="border-bottom border-gray-200 fs-7 fw-bold">
                            <tr class="text-start text-muted text-uppercase gs-0">
                                <th class="min-w-150px sorting">Nome</th>
                                <th class="min-w-150px sorting">Dosagem</th>
                                <th class="min-w-80px sorting">Validade</th>
                                <th class="min-w-80px sorting">Estado</th>
                            </tr>
                        </thead>
                        <?php foreach ($vaccines_info as $key => $value) { ?>
                            <tr>
                                <td><?php echo isset($value["vaccine_name"]) ? $value["vaccine_name"] : "N/A" ?></td>
                                <td><?php echo isset($value["administered_dosage"]) ? $value["administered_dosage"] : "N/A" ?></td>
                                <td><?php echo (new DateTime($value["due_date"]))->format("d/m/Y"); ?></td>
                                <td><?php
                                    if ($value["administered_date_status"] === 0) {
                                        echo "Não Administrada";
                                    } else if ($value["administered_date_status"] === 1) {
                                        echo "Administrada a: " . ' ' . (new DateTime($value["administered_date"]))->format("d/m/Y");;
                                    } else if ($value["administered_date_status"] === 2) {
                                        echo "Cancelada";
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

<!-- [hashed_id_administered_vaccine] => ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d
[administered_date] =>
[administered_date_status] => 0
[administered_dosage] => 12.5
[due_date] => 2023-08-12T23:00:00.000Z
[hashed_id_vaccine] => 4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce
[vaccine_name] => Covid-21
[vaccine_status] => 1 -->