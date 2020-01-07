<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $asg_header; ?></h1>
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
                  <a class="nav-link active" id="deadline-info-tab" data-toggle="pill" href="#deadline-info" role="tab" aria-controls="deadline-info" aria-selected="true">Assignment Timeline</a>
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
                  <div class="timeline">
                    <?php $last_day_str = date("d-m-Y"); ?>
                    <?php $today = date("d-m-Y"); ?>
                    <?php $now = date("Y-m-d H:i:s"); ?>
                    <?php array_push($Assignment_dates, array('date_value'=> $now, 'description'=>'You are here', 'today'=> true, 'id' => null) ); ?>
                    <?php usort($Assignment_dates, function($a, $b) {return $b['date_value'] < $a['date_value'];}); ?>
                    <?php foreach($Assignment_dates as $a):  ?>
                      <?php $earlier = true ; ?>
                      <?php if ($a['date_value']): ?>
                        <?php $earlier = (date("Y-m-d H:i:s", strtotime($a['date_value'])) < $now) ; ?>
                        <?php $date_str = date("d-m-Y", strtotime($a['date_value'])); ?>
                        <?php $time_str = "<i class='fas fa-clock'></i> ".date("H:i:s", strtotime($a['date_value'])); ?>
                        <?php $bg_color = ($earlier)?'bg-secondary':'bg-success' ; ?>
                        <?php $icon = ($earlier)?'fas fa-check-circle':'fas fa-map-marker' ; ?>
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
                                  <span><?php echo $time_str? $time_str.' - ' : '' ; ?><?php echo $a['description']; ?></span>
                              </div>
                          </div>
                        </div>
                        <?php $last_day_str = $date_str ;?>
                      <?php endif; ?>
                    <?php endforeach; ?>
                      <div>
                          <i class="fas fa-trophy bg-yellow"></i> <div class="timeline-item"><span class="timeline-body">Assignment Complete</span></div>
                      </div>
                  </div>
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