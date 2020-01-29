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
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/group/'.$asg_id); ?>">Groups</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/submit/'.$asg_id); ?>">Submission</a></li>
          <li class="breadcrumb-item active">Feedback</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card">
    <div class="card-header bg-secondary">
      <h3 class="card-title">Assignment Feedback</h3>
    </div>
    <!-- /.card-header -->
    <div class="card-body">
      <?php if ($feedback_released): ?>
        <div class="callout callout-success">
            <h5><b>Score: </b>
                <?php echo sprintf("%.2f", $indiv_score) ; ?>
            </h5>
        </div>
        <?php if (!empty($feedback)): ?>
        <div class="callout callout-success">
            <p><b>Feedback:</b></p>
            <span><?php echo $feedback; ?></span>
        </div>
        <?php endif; ?>
      <?php else: ?>
        <div class="callout callout-secondary">
          <span><i class="text-muted">No feedbacks at this moment.</i></span>
        </div>
      <?php endif; ?>
    </div>
    <!-- /.card-body -->
  </div>
  <!-- /.card -->
  </div>
</div>
<!-- /.row -->