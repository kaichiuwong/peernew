<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item active">Groups</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/submit/'.$asg_id); ?>">Submission</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title">Assignment Groups</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <table class="table table-sm table-head-fixed table-hover <?php if (!$selected_topic) echo "enable-datatable"; ?>">
                <thead>
                    <tr>
                        <th>Group Name</th>
                        <th>Group Members</th>
                        <th>Capacity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($assignment_topics as $a){ ?>
                        <?php if ($selected_topic) { ?>
                            <?php if ($a['id'] == $assignment_topic['topic_id']) { ?>
                            <tr>
                                <td><?php echo $a['topic']; ?> <span class="badge badge-info">Selected</span></td>
                                <td><a href="javascript:void(0);" data-grp-name="<?php echo $a['topic']; ?>" data-href="<?php echo site_url('assignment/topic_member/'.$a['id']); ?>" class="group_info_open"><?php echo $a['cnt']; ?></a></td>
                                <td><?php echo $a['max']; ?></td>
                                <td>
                                    <a href="<?php echo site_url('assignment/leave_group/'.$asg_id.'/'.$a['id']); ?>" class="btn btn-danger btn-sm">Leave Group</a>
                                </td>
                            </tr>
                            <?php } ?>
                        <?php } else { ?>
                            <tr>
                                <td><?php echo $a['topic']; ?></td>
                                <td><a href="javascript:void(0);" data-grp-name="<?php echo $a['topic']; ?>" data-href="<?php echo site_url('assignment/topic_member/'.$a['id']); ?>" class="group_info_open"><?php echo $a['cnt']; ?></a></td>
                                <td><?php echo $a['max']; ?></td>
                                <td>
                                    <?php if ($a['cnt'] >= $a['max']) { ?>
                                    <span class="badge badge-danger">Full</span>
                                    <?php } else { ?>
                                    <a href="<?php echo site_url('assignment/join_group/'.$asg_id.'/'.$a['id']); ?>" class="btn btn-primary btn-sm">Join Group</a>
                                    <?php } ?>
                                </td>
                            </tr>
                        <?php } ?>
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