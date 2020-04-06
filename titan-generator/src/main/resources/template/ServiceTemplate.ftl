<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
package ${basePackageName}.${moduleName?lower_case}.${servicePackageName};

import ${commonPackageName}.domain.Page;
import ${commonPackageName}.domain.PageData;
import ${basePackageName}.${moduleName?lower_case}.${domainPackageName}.${entityName}RequestDTO;
import ${basePackageName}.${moduleName?lower_case}.${domainPackageName}.${entityName}ResponseDTO;

import java.util.List;

/**
 * ${displayName} 服务
 *
 * @author titan-generator
 * @since ${aDate?iso_utc}
 */
public interface ${entityName}Service {
<#if !ignoreListMethod?? || !ignoreListMethod>

    /**
     * 获取${displayName}列表
     *
     * @param page 分页参数
     * @param keyword 搜索关键字
     * @return ${displayName}列表
     */
    PageData<${entityName}ResponseDTO> list${entityName}s(Page page, String keyword);
</#if>
<#if !ignoreSaveMethod?? || !ignoreSaveMethod>

    /**
     * 新增${displayName}
     *
     * @param requestDTO ${displayName}请求实体
     * @return 操作成功数量
     */
    Integer save${entityName}(${entityName}RequestDTO requestDTO);
</#if>
<#if !ignoreUpdateMethod?? || !ignoreUpdateMethod>

    /**
     * 更新${displayName}
     *
     * @param requestDTO ${displayName}请求实体
     * @return 操作成功数量
     */
    Integer update${entityName}(${entityName}RequestDTO requestDTO);
</#if>
<#if !ignoreGetMethod?? || !ignoreGetMethod>

    /**
     * 获取${displayName}
     *
     * @param id ${displayName}id
     * @return ${displayName}响应实体
     */
    ${entityName}ResponseDTO find${entityName}(Long id);
</#if>
<#if !ignoreRemoveMethod?? || !ignoreRemoveMethod>

    /**
     * 删除${displayName}
     *
     * @param ids 删除${displayName}id列表
     * @return 删除成功数量
     */
    Integer remove${entityName}(List<Long> ids);
</#if>
}
