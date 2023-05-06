<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>

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
		var calendar = new FullCalendar.Calendar(calendarEl, {
			headerToolbar: {
				left: "prev,next today",
				center: "title",
				right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
			},
			locale: "pt",
			editable: true,
			droppable: true, // this allows things to be dropped onto the calendar
			drop: function(arg) {
				// is the "remove after drop" checkbox checked?
				if (document.getElementById("drop-remove").checked) {
					// if so, remove the element from the "Draggable Events" list
					arg.draggedEl.parentNode.removeChild(arg.draggedEl);
				}
			}
		});

		calendar.render();
	</script>

</body>

</html>