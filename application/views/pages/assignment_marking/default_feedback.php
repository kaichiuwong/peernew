<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $asg_header; ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/group/'.$asg_id); ?>">Group Score</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/peer/'.$asg_id); ?>">Peer Score</a></li>
          <li class="breadcrumb-item active">Default Feedbacks</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/final_score/'.$asg_id); ?>">Export Score</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>



<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Default Feedbacks</h3>
      </div>
      <!-- /.card-header -->
        <div class="card-body table-responsive p-3">
        <?php if ($enable_edit): ?>
        <a href="<?php echo site_url('Marking/edit_default_feedback/'.$asg_id); ?>" class="btn btn-sm btn-primary">Edit Default Feedbacks</a>
        <?php endif ;?>
        <?php $last_section = ""; ?>
        <?php foreach($default_feedbacks as $a): ?>
        <?php if ($last_section != $a['section']): ?>
          <h4><b><?php echo (empty($a['section_desc']))?$a['section']:$a['section_desc']; ?></b></h4>
        <?php endif; ?>
        <?php $last_section = $a['section']; ?>
        <table class="table table-sm table-head-fixed table-hover">
            <tbody>
                <tr>
                    <td style="width: 100px;">
                      <span class="text-danger" data-toggle="tooltip" data-placement="top" title="Default feedback for score more than this score">
                        <input type="number" value="<?php echo $a['threshold'];?>" class="form-control input input-sm" disabled readonly />
                      </span>
                    </td>
                    <td>
                      <span><?php echo $a['feedback']; ?></span>
                    </td>
                </tr>
            </tbody>
        </table>
        <?php endforeach; ?>
        </div>
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
