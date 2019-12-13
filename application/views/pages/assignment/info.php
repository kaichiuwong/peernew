<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item active">Info</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/group/'.$asg_id); ?>">Groups</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/submit/'.$asg_id); ?>">Submission</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title">Assignment Info</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
              <ul class="nav nav-tabs" id="custom-content-above-tab" role="tablist">
                <li class="nav-item">
                  <a class="nav-link active" id="deadline-info-tab" data-toggle="pill" href="#deadline-info" role="tab" aria-controls="deadline-info" aria-selected="true">Deadlines</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" id="outcome-info-tab" data-toggle="pill" href="#outcome-info" role="tab" aria-controls="outcome-info" aria-selected="false">Outcome</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" id="scenario-info-tab" data-toggle="pill" href="#scenario-info" role="tab" aria-controls="scenario-info" aria-selected="false">Scenario</a>
                </li>
              </ul>
              <div class="tab-content" id="custom-content-above-tabContent">
                <div class="tab-pane fade show active" id="deadline-info" role="tabpanel" aria-labelledby="deadline-info-tab">

                </div>
                <div class="tab-pane fade" id="outcome-info" role="tabpanel" aria-labelledby="outcome-info-tab">
                  <?php echo $assignment['outcome']; ?>
                </div>
                <div class="tab-pane fade" id="scenario-info" role="tabpanel" aria-labelledby="scenario-info-tab">
                  <?php echo $assignment['scenario']; ?>
                </div>
              </div>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->