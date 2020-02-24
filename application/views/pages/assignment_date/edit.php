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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignment_date/index/'.$asg_id); ?>">Timeline</a></li>
          <li class="breadcrumb-item active">Edit Assignment Date</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
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
        <h3 class="card-title">Edit Assignment Date</h3>
    </div>
    <?php echo form_open('Assignment_date/edit/'.$asg_id.'/'.$Assignment_date['id'],array("class"=>"form-horizontal", 'onsubmit'=>'return validateDateValue()')); ?>
    <div class="card-body">
        <div class="alert alert-danger d-none " id="errormsg">
          <small><i class="fas fa-exclamation-triangle"></i> <span id="errorContent"></span></small>
        </div>
        <input type="hidden" name="asg_id" value="<?php echo $Assignment_date['asg_id']; ?>" />
        <input type="hidden" name="id" value="<?php echo $Assignment_date['id']; ?>" />
        <div class="form-group">
            <label for="topic" class="col-md-4 control-label">Key</label>
            <div class="col-md-12">
                <input type="text" name="key" value="<?php echo $Assignment_date['key']; ?>" class="form-control" id="key" disabled readonly/>
            </div>
        </div>
        <div class="form-group">
            <label for="topic" class="col-md-4 control-label">Description</label>
            <div class="col-md-12">
                <input type="text" name="description" value="<?php echo $Assignment_date['description']; ?>" class="form-control" id="description" />
            </div>
        </div>
        <div class="form-group">

        </div>
        <div class="form-group row">
          <div class="col-sm-6 mb-3 mb-sm-0">
            <label for="topic" class="col-md-4 control-label">Date Value<small> (YYYY-MM-DD HH:MM:SS)</small></label>
            <div class="col-md-12 input-group date" id="datetimepicker1" data-target-input="nearest">
                <div class="input-group-prepend" data-target="#datetimepicker1" data-toggle="datetimepicker">
                    <div class="input-group-text" id="picker_button"><i class="fa fa-calendar"></i></div>
                </div>
                <input type="text" id="date_value" name="date_value" data-date-format="YYYY-MM-DD HH:mm:ss" value="<?php echo $Assignment_date['date_value']; ?>" class="form-control datetimepicker-input" data-target="#datetimepicker1"/>
            </div>
          </div>
          <div class="col-sm-6">
            <label for="pair_date">Reference: <?php echo $pair_key; ?></label>
            <input type="text"  value="<?php echo $pair_date; ?>" class="form-control form-control-user" id="pair_date" readonly>
            <input type="hidden" value="<?php echo $pair_key; ?>" id="pair_key" readonly>
          </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-sm btn-primary">Save</button>
        <a href="<?php echo site_url('Assignment_date/index/'.$asg_id); ?>" class="btn btn-sm btn-secondary">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>