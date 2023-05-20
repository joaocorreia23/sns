<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<style>
	.fc-event {
		cursor: pointer;
	}

	.tooltip-inner {
		min-width: 400px !important;
	}
</style>

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
								<div id="kt_docs_fullcalendar_drag"></div>

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
		var calendarEl = document.getElementById("kt_docs_fullcalendar_drag");

		const handleCalendarEventClick = (info) => {
			if (!info.jsEvent.isTrusted) return;

			const event = info.event;

			const eventData = event._def;
			const eventAdditionalData = eventData.extendedProps;

			console.log(event);

			Swal.fire({
				icon: "info",
				iconHtml: '<i class="ki-outline ki-calendar-add text-info fs-1"></i>',
				title: eventData.title,
				text: "Deseja visualizar os detalhes da Consulta?",
				showCancelButton: true,
				confirmButtonText: "Sim, Visualizar",
				cancelButtonText: "Não, Cancelar",
				reverseButtons: true,
				allowOutsideClick: false,
				customClass: {
					confirmButton: "btn btn-primary",
					cancelButton: "btn btn-danger",
				},
				didOpen: () => {

				},
			}).then((result) => {

				if (result.isConfirmed) {
					Swal.fire({
						icon: "success",
						title: "Aguarde...",
						text: "Carregando os detalhes da Consulta!",
						showConfirmButton: false,
						allowOutsideClick: false
					});

					setInterval(() => {
						window.location.href = `./appointments/view?id=${eventAdditionalData.hashed_id_appointment}`;
					}, 1500);

				}

			})

		};

		const handleCalendarEventHover = (info) => {
			const popover = new bootstrap.Tooltip(info.el, {
				title: `
						<div class="">
							<div class="d-flex align-items-center">
								<div class="d-flex flex-column flex-grow-1 pe-2">
									<a href="#" class="text-gray-800 text-hover-primary fs-6 fw-bolder">${info.event._def.title}</a>
								</div>
							</div>
							<div class="separator mt-2 mb-5"></div>
							<div class="mx-2">
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Data:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._instance.range.start.toLocaleDateString()}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Inicio:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._instance.range.start.toLocaleTimeString()}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Fim:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._instance.range.end.toLocaleTimeString()}</span>
								</div>
							</div>
							<div class="separator my-5"></div>
							<div class="mx-2">
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Unidade de Saúde:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._def.extendedProps.health_unit_name}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Tipo de Unidade de Saúde:</span>
									${
										info.event._def.extendedProps.health_unit_type === 'Hospital Publico' ?
										`<span class="badge badge-success px-2 py-2">Hospital Publico</span>` :
										info.event._def.extendedProps.health_unit_type === 'Hospital Privado' ?
										`<span class="badge badge-danger px-2 py-2">Hospital Privado</span>` :
										info.event._def.extendedProps.health_unit_type === 'Clinica Publica' ?
										`<span class="badge badge-warning px-2 py-2">Clinica Publica</span>` :
										info.event._def.extendedProps.health_unit_type === 'Clinica Privada' ?
										`<span class="badge badge-info px-2 py-2">Clinica Privada</span>` :
										`<span class="badge badge-dark px-2 py-2">Centro de Saúde</span>`
									}
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Medico:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._def.extendedProps.doctor_first_name + ' ' + info.event._def.extendedProps.doctor_last_name}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Estado da Consulta:</span>
									${
										info.event._def.extendedProps.appointment_status === 0 ?
										`<span class="badge badge-info px-2 py-2">Pendente</span>` :
										info.event._def.extendedProps.appointment_status === 1 ?
										`<span class="badge badge-success px-2 py-2">Concluída</span>` :
										info.event._def.extendedProps.appointment_status === 2 ?
										`<span class="badge badge-warning px-2 py-2">Não Compareceu</span>` :
										info.event._def.extendedProps.appointment_status === 3 ?
										`<span class="badge badge-dark px-2 py-2">Cancelada</span>` :
										`<span class="badge badge-danger px-2 py-2">Eliminada</span>`

									}
								</div>
							</div>
							<div class="separator my-5"></div>
							<div class="mx-2">
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Utente:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._def.extendedProps.patient_first_name + ' ' + info.event._def.extendedProps.patient_last_name}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Data de Nascimento:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${new Date(info.event._def.extendedProps.patient_birth_date).toLocaleDateString()}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Género:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._def.extendedProps.patient_gender}</span>
								</div>
								<div class="d-flex flex-stack mb-2">
									<span class="text-muted me-2 fs-7 fw-bold">Número de Utente:</span>
									<span class="text-gray-800 pe-2 fs-7 fw-bold">${info.event._def.extendedProps.patient_number}</span>
								</div>
							</div>
						</div>
					`,
				customClass: "w-300px min-h-300px",
				trigger: "hover",
				html: true,
				container: "body",
			});
		}

		const handleCalendarSelect = (info) => {
			if (!info.jsEvent.isTrusted) return;

			const event = info;
			console.log(event);
		};

		const calendarEvents = [{
			url: "http://localhost:3000/api/appointments/calendar",
			method: "POST",
			error: () => {
				Swal.fire({
					icon: "error",
					title: "Oops...",
					text: "Não foi possível carregar as Consultas!",
				});
			}
		}];

		var calendar = new FullCalendar.Calendar(calendarEl, {
			headerToolbar: {
				left: "prev,next today",
				center: "title",
				right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
			},
			locale: "pt",
			slotMinTime: "07:00",
			slotMaxTime: "23:00",
			expandRows: true,
			slotEventOverlap: false,
			allDaySlot: false,
			selectable: true,
			validRange: {
				//start: new Date()
			},
			drop: function(arg) {
				// is the "remove after drop" checkbox checked?
				if (document.getElementById("drop-remove").checked) {
					// if so, remove the element from the "Draggable Events" list
					arg.draggedEl.parentNode.removeChild(arg.draggedEl);
				}
			},
			eventSources: calendarEvents,
			eventClick: (info) => handleCalendarEventClick(info),
			select: (info) => handleCalendarSelect(info),
			eventDidMount: (info) => handleCalendarEventHover(info)
		});

		calendar.render();
	</script>

</body>

</html>