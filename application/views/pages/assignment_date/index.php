<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/edit/'.$asg_id); ?>">Edit Info</a></li>
          <li class="breadcrumb-item active">Deadlines</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-md-3">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Assignment Timeline</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body">
        <!-- Main node for this component -->
        <div class="timeline">
        <?php $last_day_str = date("d-m-Y"); ?>
        <?php $now = date("Y-m-d H:i:s"); ?>
        <?php foreach($Assignment_dates as $a):  ?>
          <?php $earlier = (date("Y-m-d H:i:s", strtotime($a['date_value'])) < $now) ; ?>
          <?php $date_str = date("d-m-Y", strtotime($a['date_value'])); ?>
          <?php if ($date_str != $last_day_str) : ?>
          <div class="time-label">
            <span class="<?php echo ($earlier)?'bg-secondary':'bg-success'; ?>"><?php echo $date_str; ?></span>
          </div>
          <?php endif; ?>
          <div>
            <i class="fas <?php echo ($earlier)?'fa-check-circle bg-secondary':'fa-hourglass-half bg-yellow'; ?>"></i>
            <div class="timeline-item">
              <span class="time text-white"><i class="fas fa-clock"></i> <?php echo date("H:i:s", strtotime($a['date_value'])); ?></span>
              <h3 class="timeline-header text-bold <?php echo ($earlier)?'bg-secondary':'bg-success'; ?>"><?php echo $a['description']; ?></h3>
              <div class="timeline-body"></div>
              <div class="timeline-footer">
                <a class="btn btn-primary btn-sm">Edit</a>
              </div>
            </div>
          </div>
          <?php $last_day_str = $date_str ;?>
        <?php endforeach; ?>
          <!-- The last icon means the story is complete -->
          <div>
            <i class="fas fa-clock bg-gray"></i>
          </div>
        </div>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
  <div class="col-md-9">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Assignment Calendar</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body p-0">
        <div id="calendar"></div>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
