<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html manifest="${env['app_manifest']}" >
<head>
	<meta charset="UTF-8">
    <title>菜单树管理</title>
   	<%@ include file="/system/_script.jsp"%>
	
	<style type="text/css">
      #fm{
          margin:0;
          padding:10px 20px;
      }
      .ftitle{
          font-size:14px;
          font-weight:bold;
          padding:5px 0;
          margin-bottom:10px;
          border-bottom:1px solid #ccc;
      }
      .fitem{
          margin-bottom:5px;
      }
      .fitem label{
          display:inline-block;
          width:60px;
      }
      .input_query{
      	width: 80px;
      }
      input,textarea {
	width: 160px;
	border: 1px solid #ccc;
	padding: 2px;
}
</style>
</head>

<body>
    
 	<div id="mainWindow" class="easyui-layout" data-options="fit:true" style="display:none">
    	<!-- 查询条件  -->
		<div data-options="region:'north', title:'角色表-条件'"
			style="height: 80px; padding: 5px 80px;">
			<form id="search-form" >
				<table class="search-table">
					<tr>
						<td>
							名称:
							<input type="text" class="input_query" name="name" id="query_name"/>
						</td>
						<td>
							<a class="easyui-linkbutton"
								data-options="iconCls:'icon-search'" id="search-btn">查询</a>
							<a class="easyui-linkbutton"
								data-options="iconCls:'icon-reload'" id="reset-btn">重置</a>
						</td>

					</tr>
				</table>
			</form>
		</div>
		
		<!-- 查询结果 center -->
	    <div data-options="region:'center', title:'查询结果'">
	    	<div id="toolbar">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="onEdit()">Edit</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="onExpandAll()">Expand all</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="onCollapseAll()">Collapse all</a>
		    </div>
		    <div class="easyui-panel" style="padding:5px">
				<ul id="menuTree" class="easyui-tree" data-options="url:'/basedata/model/findModelByTree'
					,animate:true,dnd:true,lines:true,formatter:formatter
					,onDblClick:onDblClick,onClick:onClick,onDrop:onDrop
					,onAfterEdit:onAfterEdit,onBeforeExpand:onBeforeExpand,onLoadSuccess:onLoadSuccess
					,onContextMenu: function(e,node){
						e.preventDefault();
						$(this).tree('select',node.target);
						if(!node.color){//不是接口不处理
							return;
						}	
						$('#mm').menu('show',{
							left: e.pageX,
							top: e.pageY
						});
					}"></ul>
			</div>
		 </div>
	</div>
	
	<div id="mm" class="easyui-menu" style="width:120px;">
		<div onclick="editit()" data-options="iconCls:'icon-edit'">Edit</div>
	</div>
    
    <div id="dlg" class="easyui-dialog" style="width:510px;height:340px;padding:10px 20px;display:none"
            closed="true" buttons="#dlg-buttons">
        
		<legend>
			接口日志管理
		</legend>   
        <form id="fm" method="post" novalidate>
        	<input type="hidden" name="cid">
        	<input type="hidden" name="intfType">
        	<fieldset>
				<legend>接口信息(ReadOnly)</legend>  
	        	<div class="fitem">
	                <label>Parent:</label>
	                <label><div id="parentName" style="width:300px"></div></label>
	            </div>
	            <div class="fitem">
	                <label>packageName:</label>
	                <input name="packageName" class="easyui-validatebox" required="true" readOnly>
	            </div>
	            <div class="fitem">
	                <label>className:</label>
	                <input name="className" class="easyui-validatebox" required="true" readOnly>
	            </div>
	            <div class="fitem">
	                <label>funcCode:</label>
	                <input name="funcCode" class="easyui-validatebox" required="true" readOnly>
	            </div>
	            <div class="fitem">
	                <label>params:</label>
	                <input name="params" class="easyui-validatebox"  readOnly>
	            </div>
	        </fieldset>
	        <fieldset>
	        	<legend>Log注解</legend>  
	        	<div class="fitem">
	                <label>title:</label>
	                <input name="title" class="easyui-validatebox" >
	            </div>
	            <div class="fitem">
	                <label>author:</label>
	                <input name="author" class="easyui-validatebox" >
	            </div>
	            <div class="fitem">
	                <label>calls:</label>
	                <input name="calls" class="easyui-validatebox" >
	            </div>
	            <div class="fitem">
	                <label>descs:</label>
	                <input name="descs" class="easyui-validatebox" >
	            </div>
	        </fieldset>
	        <fieldset>
	        	<legend>Log配置</legend>  
	            <div class="fitem">
	                <label>接口日志类型:</label>
	                <input class="easyui-combobox" name="openType"  data-options="
									valueField: 'id',
									textField: 'name',
									data: dict_tf_intf_log_type" />
	            </div>
	            
	            <div class="fitem">
	                <label>Order count:</label>
	                <input name="orderCount" class="easyui-validatebox" >
	            </div>
	            <div class="fitem">
	                <label>备注:</label>
	                <textarea name="remark" id="lookupItem_remark" style="height:60px;width:220px"></textarea>
	            </div>
            </fieldset>
       </form>
	   
	     <div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onSave()">Save</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
	    </div>
	 </div>
    
  
    <script type="text/javascript" src="/scripts/basedata/modelTree.js"></script>
    <script type="text/javascript">
	    function onLoadSuccess (){
	    	openRoot();
	    }
    </script>
    
    <%@ include file="/system/_foot.jsp"%>
</body>
</html>