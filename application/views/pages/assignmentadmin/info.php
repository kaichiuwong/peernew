<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $asg_header; ?></h1>
      </div>
      <div class="col-sm-6">
      <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item active">Info</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_date/index/'.$asg_id); ?>">Timeline</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
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
          <a href="<?php echo site_url('Assignmentadmin/edit/'.$asg_id); ?>" class="btn btn-primary btn-sm">Edit Info</a>
              <ul class="nav nav-tabs" id="custom-content-above-tab" role="tablist">
                <li class="nav-item">
                  <a class="nav-link active" id="outcome-info-tab" data-toggle="pill" href="#outcome-info" role="tab" aria-controls="outcome-info" aria-selected="false">Outcome</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" id="scenario-info-tab" data-toggle="pill" href="#scenario-info" role="tab" aria-controls="scenario-info" aria-selected="false">Scenario</a>
                </li>
              </ul>
              <div class="tab-content" id="custom-content-above-tabContent">
                <div class="tab-pane fade show active" id="outcome-info" role="tabpanel" aria-labelledby="outcome-info-tab">
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