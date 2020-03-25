<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $unit_header; ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit'); ?>">Unit List</a></li>
          <li class="breadcrumb-item active">Edit Unit</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Staff_list/index/'.$unit_id); ?>">Staff List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$unit_id); ?>">Groups</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Create Unit</h3>
    </div>
    <?php echo form_open('Unit/edit/'.$unit_id,array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <div class="form-group">
            <label for="unit_code" class="col-md-4 control-label"><span class="text-danger">*</span>Unit Code <small class="text-danger"><?php if ($error_msg) echo $error_msg; ?></small></label>
            <div class="col-md-12">
                <input type="text" name="unit_code" value="<?php echo $unit_info->unit_code; ?>" class="form-control" id="unit_code" required/>
                <span class="text-danger"><?php echo form_error('unit_code');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="unit_desc" class="col-md-4 control-label">Unit Description</label>
            <div class="col-md-12">
                <input type="text" name="unit_desc" value="<?php echo $unit_info->unit_description; ?>" class="form-control" id="unit_desc" />
                <span class="text-danger"><?php echo form_error('unit_desc');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="sem" class="col-md-4 control-label"><span class="text-danger">*</span>Semester</label>
            <div class="col-md-12">
                <select name="sem" class="form-control select2bs4" required>
                    <option value="" disabled selected>-- Semester List --</option>
                    <?php 

                    foreach($sem_list as $sem)
                    {
                        if ($unit_info->sem) {
                            $selected = ($sem['sem'] == $unit_info->sem ) ? ' selected ' : ' ';
                        }

                        echo '<option value="'.$sem['sem'].'" '.$selected.'>'. $sem['description'] .'</option>';
                    } 
                    ?>
                </select>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary btn-sm" name="submit">Save Changes</button>
        <a href="<?php echo site_url('Unit'); ?>" class="btn btn-sm btn-secondary">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>