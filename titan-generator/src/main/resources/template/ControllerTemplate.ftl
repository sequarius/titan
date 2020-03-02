<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
package ${basePackageName}.${moduleName}.${controllerPackageName};

import ${commonPackageName}.domain.Page;
import ${commonPackageName}.domain.PageData;
import ${commonPackageName}.domain.Response;
import ${commonPackageName}.message.CommonMessage;
import ${basePackageName}.${moduleName}.${domainPackageName}.${entityName}RequestDTO;
import ${basePackageName}.${moduleName}.${domainPackageName}.${entityName}ResponseDTO;
import ${basePackageName}.${moduleName}.${servicePackageName}.${entityName}Service;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.http.RequestEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;

/**
 * ${displayName}Controller
 *
 * @author titan-generator
 * @since ${aDate?iso_utc}
 */
@RestController
@Api(tags = "${displayName}API", description = "${displayName}相关操作")
@RequestMapping("/${moduleName}")
@Slf4j
public class ${entityName}Controller {

    public static final String ENTITY_NAME = "${displayName}";

    @Resource
    private CommonMessage commonMessage;

    @Resource
    private ${entityName}Service ${camelEntityName}Service;
<#if !ignoreListMethod?? || !ignoreListMethod>

    @GetMapping("${url!('/'+camelEntityName)}s")
    @ApiOperation("查看${displayName}列表")
    @RequiresPermissions("${moduleName}:${camelEntityName}:view")
    public Response<PageData<${entityName}ResponseDTO>> list(@Valid Page page, String keyword) {
        return Response.success(${camelEntityName}Service.list${entityName}s(page, keyword));
    }
</#if>
<#if !ignoreGetMethod?? || !ignoreGetMethod>

    @GetMapping("${url!('/'+camelEntityName)}/{id}")
    @ApiOperation("查看${displayName}")
    @RequiresPermissions("${moduleName}:${camelEntityName}:view")
    public Response<${entityName}ResponseDTO> find${entityName}(@PathVariable Long id) {
        ${entityName}ResponseDTO ${camelEntityName} = ${camelEntityName}Service.find${entityName}(id);
        if (${camelEntityName} == null) {
            return Response.fail(commonMessage.getEntityNotFound(ENTITY_NAME));
        }
        return Response.success(${camelEntityName});
    }
</#if>
<#if !ignoreRemoveMethod?? || !ignoreRemoveMethod>

    @DeleteMapping("${url!('/'+camelEntityName)}")
    @ApiOperation("删除${displayName}")
    @RequiresPermissions("${moduleName}:${camelEntityName}:remove")
    public Response<${entityName}ResponseDTO> remove${entityName}(RequestEntity<List<Long>> ids) {
        if (ids.getBody() == null || ids.getBody().isEmpty()) {
            return Response.fail(commonMessage.getEmptyId());
        }
        Integer result = ${camelEntityName}Service.remove${entityName}(ids.getBody());
        if (result < 1) {
            return Response.fail(commonMessage.getEntityRemoveFailed(ENTITY_NAME));
        }
        return Response.success(commonMessage.getEntityRemoveSuccess(ENTITY_NAME, result));
    }
</#if>
<#if !ignoreSaveMethod?? || !ignoreSaveMethod>

    @PostMapping("${url!('/'+camelEntityName)}")
    @ApiOperation("新增${displayName}")
    @RequiresPermissions("${moduleName}:${camelEntityName}:save")
    public Response<String> add${entityName}(@Valid @RequestBody ${entityName}RequestDTO requestDTO) {
        if (${camelEntityName}Service.save${entityName}(requestDTO) > 0) {
            return Response.success(commonMessage.getEntitySaveSuccess(ENTITY_NAME));
        }
        return Response.fail(commonMessage.getEntitySaveFailed(ENTITY_NAME));
    }
</#if>
<#if !ignoreUpdateMethod?? || !ignoreUpdateMethod>

    @PutMapping("${url!('/'+camelEntityName)}")
    @ApiOperation("更新${displayName}")
    @RequiresPermissions("${moduleName}:${camelEntityName}:update")
    public Response<String> update${entityName}(@Valid @RequestBody ${entityName}RequestDTO requestDTO) {
        if (requestDTO.getId() == null) {
            return Response.fail(commonMessage.getEmptyId());
        }
        Integer result = ${camelEntityName}Service.update${entityName}(requestDTO);
        if (result > 0) {
            return Response.success(commonMessage.getEntityUpdateSuccess(ENTITY_NAME));
        }

        if (result == -1) {
            return Response.fail(commonMessage.getEntityNotFound(ENTITY_NAME));
        }
        return Response.fail(commonMessage.getEntityUpdateFailed(ENTITY_NAME));
    }
</#if>
}
