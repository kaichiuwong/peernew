<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Create Assignment</h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit'); ?>">Unit List</a></li>
          <li class="breadcrumb-item active">Create Assignment</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Create Assignment</h3>
    </div>
    <?php echo form_open('Assignmentadmin/add/'.$unit_id,array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <div class="form-group">
            <label for="type" class="col-md-4 control-label"><span class="text-danger">*</span>Type</label>
            <div class="col-md-12">
                <select name="type" class="form-control select2bs4" required>
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
                <input type="hidden" name="unit_id" value="<?php echo $unit_id; ?>" class="form-control" id="unit_id" required readonly/>
                <input type="text" name="unit_desc" value="<?php echo $unit_header; ?>" class="form-control" id="unit_id" readonly/>
            </div>
        </div>
        <div class="form-group">
            <label for="group_set" class="col-md-4 control-label">Predefine Group Set</label>
            <div class="col-md-12">
                <select name="group_set" class="form-control select2bs4">
                    <option value="" disabled selected>-- Group Set --</option>
                    <?php 
                    foreach($unit_set as $set)
                    {
                        $selected = '';
                        if ($this->input->post('group_set')) {
                            $selected = ($set['id'] == $this->input->post('group_set')) ? ' disabled' : ' selected="selected" ';
                        }

                        echo '<option value="'.$set['id'].'" '.$selected.'>'.$set['desc']. ' ('.$set['cnt'].' Groups)'.'</option>';
                    } 
                    ?>
                </select>
                <span class="text-danger"><?php echo form_error('group_set');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="title" class="col-md-4 control-label"><span class="text-danger">*</span>Title</label>
            <div class="col-md-12">
                <input type="text" name="title" value="<?php echo $this->input->post('title'); ?>" class="form-control" id="title" required />
                <span class="text-danger"><?php echo form_error('title');?></span>
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
        <button type="submit" class="btn btn-primary btn-sm" name="submit">Create</button>
        <a href="<?php echo site_url('Unit'); ?>" class="btn btn-sm btn-secondary">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>