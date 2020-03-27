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
          <li class="breadcrumb-item active">Info</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Staff_list/index/'.$unit_id); ?>">Staff List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_group/index/'.$unit_id); ?>">Group Set</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Unit Info</h3>
    </div>
    <div class="card-body">
        <a href="<?php echo site_url('Unit/edit/'.$unit_id); ?>" class="btn btn-primary btn-sm">Edit Unit</a>
        <div class="form-group">
            <label for="unit_code" class="col-md-4 control-label">Unit Code</label>
            <div class="col-md-12">
                <input type="text"   value="<?php echo $unit_info->unit_code; ?>" class="form-control" id="unit_code" readonly/>
                <span class="text-danger"><?php echo form_error('unit_code');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="unit_desc" class="col-md-4 control-label">Unit Description</label>
            <div class="col-md-12">
                <input type="text" value="<?php echo $unit_info->unit_description; ?>" class="form-control" id="unit_desc" readonly/>
                <span class="text-danger"><?php echo form_error('unit_desc');?></span>
            </div>
        </div>
        <div class="form-group">
            <label for="sem" class="col-md-4 control-label">Semester</label>
            <div class="col-md-12">
                <select class="form-control" readonly disabled>
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
</div>