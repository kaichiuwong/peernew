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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item active">Timeline</li>
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
                  <div class="timeline">
                    <?php $last_day_str = date("d-m-Y"); ?>
                    <?php $today = date("d-m-Y"); ?>
                    <?php $now = date("Y-m-d H:i:s"); ?>
                    <?php array_push($Assignment_dates, array('date_value'=> $now, 'description'=>'We are here', 'today'=> true, 'id' => null, 'key' => '_TODAY') ); ?>
                    <?php usort($Assignment_dates, function($a, $b) {
                        if ($b['date_value'] != $a['date_value']) {
                          return $b['date_value'] < $a['date_value'];
                        }
                        else {
                          return $b['key'] > $a['key'];
                        }
                        }); ?>
                    <?php foreach($Assignment_dates as $a):  ?>
                      <?php $earlier = true ; ?>
                      <?php $date_str = "Not yet defined"; ?>
                      <?php $time_str = "<i class='fas fa-exclamation-circle'></i> Not yet defined"; ?>
                      <?php $bg_color = "bg-danger" ; ?>
                      <?php $icon = "far fa-times-circle" ; ?>
                      <?php if ($a['date_value']): ?>
                        <?php $earlier = (date("Y-m-d H:i:s", strtotime($a['date_value'])) < $now) ; ?>
                        <?php $date_str = date("d-m-Y", strtotime($a['date_value'])); ?>
                        <?php $time_str = "<i class='fas fa-clock'></i> ".date("H:i:s", strtotime($a['date_value'])); ?>
                        <?php $bg_color = ($earlier)?'bg-secondary':'bg-success' ; ?>
                        <?php $icon = ($earlier)?'fas fa-check-circle':'fas fa-map-marker' ; ?>
                      <?php endif; ?>
                      <?php if (isset($a['today'])) : ?>
                        <?php     $icon = 'fas fa-walking'; ?>
                        <?php     $bg_color = 'bg-primary'; ?>
                        <?php     $time_str = ''; ?>
                      <?php endif; ?>
                      <?php if ($date_str != $last_day_str) : ?>
                      <div class="time-label">
                        <span class="<?php echo ($date_str == $today) ? "bg-primary" : $bg_color; ?>"><?php echo $date_str; ?></span>
                      </div>
                      <?php endif; ?>
                      <div>
                        <i class="<?php echo $icon.' '.$bg_color ; ?>"></i>
                        <div class="timeline-item">
                            <div class="timeline-header <?php echo $bg_color; ?>">
                              <div class="row">
                                <span class="col-md-9"><?php echo $time_str? $time_str.' - ' : '' ; ?><?php echo $a['description']; ?></span>
                                <?php if (!isset($a['today'])) : ?>
                                  <span class="col-md-3  text-right"><a href="<?php echo site_url('assignment_date/edit/'.$a['asg_id'].'/'.$a['id']);?>" class="btn btn-sm btn-primary">Edit</a></span>
                                <?php endif; ?>
                              </div>
                            </div>
                        </div>
                      </div>
                      <?php $last_day_str = $date_str ;?>
                    <?php endforeach; ?>
                      <div>
                          <i class="fas fa-trophy bg-yellow"></i> <div class="timeline-item"><span class="timeline-body">Assignment Complete</span></div>
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
        <div class="alert alert-danger d-none" role="alert" id="calendar-alert">
          Fail to load the event list.
        </div>
        <div id="asg-calendar" data-jsonurl="<?php echo site_url('Assignment_date/json/'.$asg_id); ?>"></div>
      </div>
      <div class="overlay dark" id="loading-calendar-overlay"> 
          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
        </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->

