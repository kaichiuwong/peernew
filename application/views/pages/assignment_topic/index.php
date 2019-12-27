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
          <li class="breadcrumb-item active">Group List</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Group List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
	  <a href="<?php echo site_url('assignment_topic/add/'.$asg_id); ?>" class="btn btn-success btn-sm">Create Groups</a> 

        <table class="table table-sm table-head-fixed table-hover enable-datatable">
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
                <tr>
                    <td><?php echo $a['topic']; ?></td>
                    <td><a href="javascript:void(0);" data-grp-name="<?php echo $a['topic']; ?>" data-href="<?php echo site_url('assignment_topic/topic_member/'.$a['id']); ?>" class="group_info_open"><?php echo $a['cnt']; ?></a></td>
                    <td><?php echo $a['max']; ?></td>
                    <td>
                        <a href="<?php echo site_url('assignment_topic/edit/'.$asg_id.'/'.$a['id']); ?>" class="btn btn-info btn-sm">Edit</a> 
                        <a href="<?php echo site_url('assignment_topic/remove/'.$asg_id.'/'.$a['id']); ?>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
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
