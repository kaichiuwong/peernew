<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Assignment List</h1>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Assignment List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Unit</th>
                    <th>Title</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($assignments as $a){ ?>
                <tr>
                    <td><?php echo $a['unit_code']; ?></td>
                    <td><?php echo $a['asg_title']; ?></td>
                    <td>
                        <a href="<?php echo site_url('assignment/info/'.$a['asg_id']); ?>" class="btn btn-info btn-sm">Select</a> 
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