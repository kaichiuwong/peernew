<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/group/'.$asg_id); ?>">Group Score</a></li>
          <li class="breadcrumb-item active">Edit Feedback</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/peer/'.$asg_id); ?>">Peer Score</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/final_score/'.$asg_id); ?>">Export Score</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card">
      <div class="card-header bg-secondary">
        <h3 class="card-title">Edit Group Feedback for <?php echo $summary[0]['topic'] ; ?></h3>
        <!-- /.card-tools -->
      </div>
      <!-- /.card-header -->
      <?php echo form_open('Marking/save_group_submission/',array("class"=>"form-horizontal", "id"=>"remark_form")); ?>
      <div class="card-body">
        <input type="hidden" id="remark_asg_id" name="asg_id" value="<?php echo $summary[0]['asg_id']; ?>" />
        <input type="hidden" id="remark_topic_id" name="topic_id" value="<?php echo $summary[0]['topic_id']; ?>" />
        <input type="hidden" id="remark_score_id" name="score_id" value="<?php echo $summary[0]['score_id']; ?>" />
        <div class="col-md-12">
            <textarea name="remark" id="remark" class="form-control textarea enable-editor" rows="5"><?php echo $summary[0]['remark']; ?></textarea>
        </div>
      </div>
      <!-- /.card-body -->
      <div class="card-footer">
        <button type="button" class="btn btn-primary btn-sm remark_submit_btn">Save</button> 
        <a href="<?php echo site_url('Marking/group/'.$asg_id); ?>" class="btn btn-secondary btn-sm">Cancel</a>
        <span class='badge d-none' id="status_remark"></span>
      </div>
      <?php echo form_close(); ?>
      <!-- /.card-footer -->
    </div>
    <!-- /.card -->
  </div>
</div>