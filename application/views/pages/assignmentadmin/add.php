<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Create Assignment</h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item active">Create </li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Create Assignment</h3>
    </div>
    <?php echo form_open('Assignmentadmin/add',array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <div class="form-group">
            <label for="type" class="col-md-4 control-label"><span class="text-danger">*</span>Type</label>
            <div class="col-md-12">
                <select name="type" class="form-control" required>
                    <option value="" disabled selected>-- Assignment Type --</option>
                    <?php 
                    $type_values = array(
                        '1'=>'Group Assignment'
                    );

                    foreach($type_values as $value => $display_text)
                    {
                        $selected = ($value == $this->input->post('type')) ? ' disabled' : ' selected="selected" ';

                        echo '<option value="'.$value.'" '.$selected.'>'.$display_text.'</option>';
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
                        $selected = ($unit['id'] == $this->input->post('unit_id')) ? ' selected="selected"' : "";

                        echo '<option value="'.$unit['id'].'" '.$selected.'>'.$unit['unit_code'] . ' (' . $unit['sem'] .') - '. $unit['unit_description'].'</option>';
                    } 
                    ?>
                </select>
                <span class="text-danger"><?php echo form_error('unit_id');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="title" class="col-md-4 control-label">Title</label>
            <div class="col-md-12">
                <input type="text" name="title" value="<?php echo $this->input->post('title'); ?>" class="form-control" id="title" />
                <span class="text-danger"><?php echo form_error('title');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="group_num" class="col-md-4 control-label"><span class="text-danger">*</span>Total Number of Groups</label>
            <div class="col-md-12">
                <input type="number" min="1" step="1" name="group_num" value="1" class="form-control" id="group_num" required />
                <span class="text-danger"><?php echo form_error('group_num');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="max" class="col-md-4 control-label"><span class="text-danger">*</span>Maximum capacity per group</label>
            <div class="col-md-12">
                <input type="number" min="1" step="1" name="max" value="1" class="form-control" id="max" required />
                <span class="text-danger"><?php echo form_error('max');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="prefix" class="col-md-4 control-label">Group Name Prefix</label>
            <div class="col-md-12">
                <input type="text" name="prefix" value="" class="form-control" id="prefix" />
            </div>
        </div>
        <div class="form-group">
            <label for="outcome" class="col-md-4 control-label">Outcome</label>
            <div class="col-md-12">
                <textarea name="outcome" class="form-control textarea enable-editor" id="outcome" rows="5"><?php echo $this->input->post('outcome'); ?></textarea>
            </div>
        </div>
        <div class="form-group">
            <label for="scenario" class="col-md-4 control-label">Scenario</label>
            <div class="col-md-12">
                <textarea name="scenario" class="form-control textarea enable-editor" id="scenario" rows="5"><?php echo $this->input->post('scenario'); ?></textarea>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary">Create</button>
    </div>
    <?php echo form_close(); ?>
</div>