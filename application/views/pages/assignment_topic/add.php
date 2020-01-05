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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_date/index/'.$asg_id); ?>">Timeline</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item active">Create Groups</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Staff_list/index/'.$asg_id); ?>">Staff List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Create Groups</h3>
    </div>
    <?php echo form_open('assignment_topic/add/'.$asg_id,array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <input type="hidden" name="assign_id" value="<?php echo $asg_id; ?>" />
        <div class="form-group">
            <label for="group_num" class="col-md-4 control-label"><span class="text-danger">*</span>Total Number of Groups</label>
            <div class="col-md-12">
                <input type="number" min="1" step="1" name="group_num" value="1" class="form-control" id="group_num" required />
                <span class="text-danger"><?php echo form_error('group_num');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="max" class="col-md-4 control-label"><span class="text-danger">*</span>Maximum Capacity per group</label>
            <div class="col-md-12">
                <input type="number" min="1" step="1" name="max" value="1" class="form-control" id="max" required />
                <span class="text-danger"><?php echo form_error('max');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="prefix" class="col-md-4 control-label">Group Name Prefix</label>
            <div class="col-md-12">
                <input type="text" name="prefix" value="Group" class="form-control" id="prefix" />
            </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary btn-sm">Create</button>
        <a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>" class="btn btn-sm btn-secondary">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>