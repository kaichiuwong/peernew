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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit/info/'.$unit_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Staff_list/index/'.$unit_id); ?>">Staff List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_student_list/index/'.$unit_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_group/index/'.$unit_id); ?>">Group Set</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_group/group/'.$unit_id.'/'.$set_id); ?>">Set: <?php echo $set_info['desc']; ?></a></li>
          <li class="breadcrumb-item active">Student List</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>



<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Student List for Set <?php echo $set_info['desc']; ?></h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Current Group</th>
                    <th>Actions</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($students as $a){ ?>
                <tr>
                <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['username']; ?> <?php if ($a['enable'] == 0) : ?><span class="badge badge-danger">Withdrawn</sapn><?php endif; ?></a></td>
                <td>
                <span id="current_group_<?php echo $a['username']; ?>">
                <?php if (empty($a['group_id'])): ?>
                  <b class="text-muted"><i>*** No Group ***</i></b>
                <?php else: ?>
                <?php foreach($group_list as $g): ?>
                  <?php if ($g['unit_group_id'] == $a['group_id']) { echo $g['group_desc'] ; break; } ?>
                <?php endforeach; ?>
                <?php endif; ?>
                </span>
                </td>
                    <td>
                    <?php echo form_open('Unit_group/assign_grp/'.$unit_id.'/'.$set_id, array("class"=>"form-horizontal grp_assign_form", "data-username" => $a['username'], "id"=>"grp_assign_".$a['username'])); ?>
                        <div class="input-group">
                            <input type="hidden" id="old_grp_id_<?php echo $a['username']; ?>" name="old_grp_id" value="<?php echo $a['group_id']; ?>" />
                            <input type="hidden" id="user_id_<?php echo $a['username']; ?>" name="user_id" value="<?php echo $a['username']; ?>" />
                            <input type="hidden" id="set_id_<?php echo $a['username']; ?>" name="set_id" value="<?php echo $set_id; ?>" />
                            <input type="hidden" id="grp_list_url_<?php echo $a['username']; ?>" value="<?php echo site_url('Unit_group/grp_list_html/'.$set_id.'/'); ?>" />
                            <select id="group_id_<?php echo $a['username']; ?>" name="group_id" class="form-control-sm group_select_list" required  <?php if ($a['enable'] == 0) : ?> disabled <?php endif; ?> >
                                <option value="" disabled selected>*** Select a New Group ***</option>
                                <?php foreach($group_list as $g){ ?>
                                <option value="<?php echo $g['unit_group_id']; ?>" <?php echo ($g['cnt'] >= $g['max'])? "disabled":"" ;?>><?php echo $g['group_desc'] . ' ('.$g['cnt'].'/'.$g['max'].')'; ?></option>
                                <?php }?>
                            </select>
                            <span class="input-group-btn">
                                <button class="btn btn-primary btn-sm submit_btn" type="submit" id="submit_btn_<?php echo $a['username']; ?>" tabindex="-1" <?php if ($a['enable'] == 0) : ?> disabled <?php endif; ?> >Assign</button>
                            </span>
                        </div>
                    <?php echo form_close(); ?>
                    </td>
                    <td><span id="status_<?php echo $a['username']; ?>" class="badge"></span></td>
                </tr>
                <?php } ?>
            </tbody>
        </table>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
