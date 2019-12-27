<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
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
        <table class="table table-head-fixed table-hover">
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
                        <a href="<?php echo site_url('Marking/save/'.$asg_id.'/'.$a['id']); ?>" class="btn btn-info btn-sm">Save</a> 
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
