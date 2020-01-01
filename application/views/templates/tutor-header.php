<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title><?php echo SYSTEM_FRIENDLY_NAME;?></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="refresh" content = "<?php echo SESSION_EXPIRE_TIME*2;?>; url=<?php echo site_url("Usercontrol/logout"); ?>">
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/fontawesome-free/css/all.min.css">
  <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/datatables-bs4/css/dataTables.bootstrap4.css">
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/summernote/summernote-bs4.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha14/css/tempusdominus-bootstrap-4.min.css" />
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/fullcalendar-core/main.css" />
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/fullcalendar-daygrid/main.css" />
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/fullcalendar-timegrid/main.css" />
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/plugins/fullcalendar-list/main.css" />
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/dist/css/adminlte.min.css">
  <link rel="stylesheet" href="<?php echo base_url(); ?>/assets/dist/css/pas.css?t=<?php echo rand(); ?>">
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<!-- Site wrapper -->
<div class="wrapper">