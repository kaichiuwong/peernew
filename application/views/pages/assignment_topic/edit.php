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
          <li class="breadcrumb-item active">Edit Group Detail</li>
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
        <h3 class="card-title">Edit Group Detail</h3>
    </div>
    <?php echo form_open('assignment_topic/edit/'.$asg_id.'/'.$assignment_topic['id'],array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <div class="form-group">
            <label for="assign_id" class="col-md-4 control-label">Assignment</label>
            <div class="col-md-12">
                <select name="assign_id" class="form-control" disabled>
                    <option value='<?php echo $assignment_topic['assign_id']; ?>' selected><?php echo $this->session->userdata('asg_header');?></option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="topic" class="col-md-4 control-label">Group Name</label>
            <div class="col-md-12">
                <input type="text" name="topic" value="<?php echo ($this->input->post('topic') ? $this->input->post('topic') : $assignment_topic['topic']); ?>" class="form-control" id="topic" />
            </div>
        </div>
        <div class="form-group">
            <label for="max" class="col-md-4 control-label">Maximum Capacity</label>
            <div class="col-md-12">
                <input type="number" min="1" step="1" required name="max" value="<?php echo ($this->input->post('max') ? $this->input->post('max') : $assignment_topic['max']); ?>" class="form-control" id="max" />
                <span class="text-danger"><?php echo form_error('max');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="topic_desc" class="col-md-4 control-label">Group Description</label>
            <div class="col-md-12">
                <textarea name="topic_desc" class="form-control" id="topic_desc"><?php echo ($this->input->post('topic_desc') ? $this->input->post('topic_desc') : $assignment_topic['topic_desc']); ?></textarea>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-sm btn-primary">Save</button>
        <a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>" class="btn btn-sm btn-secondary">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>