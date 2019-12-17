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
          <li class="breadcrumb-item active">Edit Info</li>
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

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Edit Assignment</h3>
    </div>
    <?php echo form_open('Assignmentadmin/edit/'.$assignment['id'],array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <div class="form-group">
            <label for="type" class="col-md-4 control-label"><span class="text-danger">*</span>Type</label>
            <div class="col-md-12">
                <select name="type" class="form-control" required>
                    <option value="" disabled>-- Assignment Type --</option>
                    <?php 
                    $type_values = array(
                        '1'=>'Group Assignment'
                    );

                    foreach($type_values as $value => $display_text)
                    {
                        $selected = ($value == $assignment['type']) ? ' selected="selected"' : "";
                        echo '<option value="'.$value.'" '.$selected.' >'.$display_text.'</option>';
                    } 
                    ?>
                </select>
                <span class="text-danger"><?php echo form_error('type');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="unit_id" class="col-md-4 control-label"><span class="text-danger">*</span>Unit</label>
            <div class="col-md-12">
                <select name="unit_id" class="form-control" required>
                    <option value="" disabled selected>-- Unit --</option>
                    <?php 
                    foreach($all_units as $unit)
                    {
                        $selected = ($unit['id'] == $assignment['unit_id']) ? ' selected="selected"' : "";

                        echo '<option value="'.$unit['id'].'" '.$selected.'>'.$unit['unit_code'].' - '. $unit['unit_description'].'</option>';
                    } 
                    ?>
                </select>
                <span class="text-danger"><?php echo form_error('unit_id');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="title" class="col-md-4 control-label">Title</label>
            <div class="col-md-12">
                <input type="text" name="title" value="<?php echo ($this->input->post('title') ? $this->input->post('title') : $assignment['title']); ?>" class="form-control" id="title" />
                <span class="text-danger"><?php echo form_error('title');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="outcome" class="col-md-4 control-label">Outcome</label>
            <div class="col-md-12">
                <textarea name="outcome" class="form-control textarea enable-editor" id="outcome" rows="5"><?php echo ($this->input->post('outcome') ? $this->input->post('outcome') : $assignment['outcome']); ?></textarea>
            </div>
        </div>
        <div class="form-group">
            <label for="scenario" class="col-md-4 control-label">Scenario</label>
            <div class="col-md-12">
                <textarea name="scenario" class="form-control textarea enable-editor" id="scenario" rows="5"><?php echo ($this->input->post('scenario') ? $this->input->post('scenario') : $assignment['scenario']); ?></textarea>
            </div>
        </div>
        
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary">Save Change</button>
    </div>
    <?php echo form_close(); ?>
</div>