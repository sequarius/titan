<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
package ${basePackageName}.${moduleName?lower_case}.${servicePackageName}.impl;

import ${basePackageName}.${domainPackageName}.${doEntityName};
import ${basePackageName}.${domainPackageName}.${doEntityName}Example;
import ${basePackageName}.repository.${doEntityName}Mapper;
import ${commonPackageName}.domain.Page;
import ${commonPackageName}.domain.PageData;
import ${basePackageName}.${moduleName?lower_case}.${domainPackageName}.${entityName}RequestDTO;
import ${basePackageName}.${moduleName?lower_case}.${domainPackageName}.${entityName}ResponseDTO;
import ${basePackageName}.${moduleName?lower_case}.${servicePackageName}.${entityName}Service;
import ${commonPackageName}.util.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import lombok.extern.slf4j.Slf4j;

import javax.annotation.Resource;
import java.util.List;

/**
 * ${displayName} 服务基础实现
 *
 * @author titan-generator
 * @since ${aDate?iso_utc}
 */
@Service
@Slf4j
public class ${entityName}ServiceImpl implements ${entityName}Service {

    @Resource
    private ${doEntityName}Mapper ${camelEntityName}Mapper;
<#if !ignoreListMethod?? || !ignoreListMethod>

    /**
     * 获取${displayName}列表
     *
     * @param page 分页参数
     * @param keyword 搜索关键字
     * @return ${displayName}列表
     */
    @Override
    public PageData<${entityName}ResponseDTO> list${entityName}s(Page page, String keyword) {
        ${doEntityName}Example example = new ${doEntityName}Example();
        example.setPage(page);
        example.setOrderByClause("id DESC");
<#if !flagDelete?? || !flagDelete>
<#if searchableFieldNames?size!=0>
        if (!StringUtils.isEmpty(keyword)) {
<#list searchableFieldNames as fieldName>
            example.or().and${fieldName?cap_first}Like(keyword + "%");
</#list>
        }
</#if>
</#if>
<#if flagDelete?? && flagDelete>
<#if searchableFieldNames?size!=0>
        if (!StringUtils.isEmpty(keyword)) {
<#list searchableFieldNames as fieldName>
            example.or().andDeletedEqualTo(false).and${fieldName?cap_first}Like(keyword + "%");
</#list>
        }else{
            example.createCriteria().andDeletedEqualTo(false);
        }
</#if>
</#if>
        List<${entityName}ResponseDTO> data = BeanUtils.copyList(${camelEntityName}Mapper.selectByExample(example), ${entityName}ResponseDTO.class);
        long totalCount = ${camelEntityName}Mapper.countByExample(example);
        return new PageData<>(data,totalCount,page);
    }
</#if>
<#if !ignoreSaveMethod?? || !ignoreSaveMethod>

    /**
     * 新增${displayName}
     *
     * @param requestDTO ${displayName}请求实体
     * @return 操作成功数量
     */
    @Override
    public Integer save${entityName}(${entityName}RequestDTO requestDTO) {
        ${doEntityName} ${camelEntityName}DO = new ${doEntityName}();
        BeanUtils.copyProperties(requestDTO, ${camelEntityName}DO);
        return ${camelEntityName}Mapper.insertSelective(${camelEntityName}DO);
    }
</#if>
<#if !ignoreUpdateMethod?? || !ignoreUpdateMethod>

    /**
     * 更新${displayName}
     *
     * @param requestDTO ${displayName}请求实体
     * @return 操作成功数量
     */
    @Override
    public Integer update${entityName}(${entityName}RequestDTO requestDTO) {
        ${doEntityName} ${camelEntityName}DO = find${doEntityName}ById(requestDTO.getId());
        if (${camelEntityName}DO == null) {
            return -1;
        }
        BeanUtils.copyPropertiesIgnoreNull(requestDTO, ${camelEntityName}DO);
        return ${camelEntityName}Mapper.updateByPrimaryKeySelective(${camelEntityName}DO);
    }
</#if>
<#if !ignoreGetMethod?? || !ignoreGetMethod>

    /**
     * 获取${displayName}
     *
     * @param id ${displayName}id
     * @return ${displayName}响应实体
     */
    @Override
    public ${entityName}ResponseDTO find${entityName}(Long id) {
        ${doEntityName} ${camelEntityName}DO = find${doEntityName}ById(id);
        if (${camelEntityName}DO == null) {
            return null;
        }
        ${entityName}ResponseDTO ${camelEntityName}DTO = new ${entityName}ResponseDTO();
        BeanUtils.copyProperties(${camelEntityName}DO, ${camelEntityName}DTO);
        return ${camelEntityName}DTO;
    }
</#if>
<#if !ignoreRemoveMethod?? || !ignoreRemoveMethod>

    /**
     * 删除${displayName}
     *
     * @param ids 删除${displayName}id列表
     * @return 删除成功数量
     */
    @Override
    public Integer remove${entityName}(List<Long> ids) {
<#if !flagDelete?? || !flagDelete>
        ${doEntityName}Example example = new ${doEntityName}Example();
        example.createCriteria().andIdIn(ids);
        return ${camelEntityName}Mapper.deleteByExample(example);
</#if>
<#if flagDelete?? && flagDelete>
        ${doEntityName} ${camelEntityName} = new ${doEntityName}();
        ${camelEntityName}.setDeleted(true);
        ${doEntityName}Example example = new ${doEntityName}Example();
        example.createCriteria().andIdIn(ids).andDeletedEqualTo(false);
        return ${camelEntityName}Mapper.updateByExampleSelective(${camelEntityName},example);
</#if>
    }
</#if>

    /**
     * 通过id获取DO
     *
     * @param id ${displayName}id
     * @return ${displayName}响应实体
     */
    private ${doEntityName} find${doEntityName}ById(Long id) {
<#if !flagDelete?? || !flagDelete>
        return ${camelEntityName}Mapper.selectByPrimaryKey(id);
</#if>
<#if flagDelete?? && flagDelete>
        ${doEntityName}Example example = new ${doEntityName}Example();
        example.createCriteria().andDeletedEqualTo(false).andIdEqualTo(id);
        List<${doEntityName}> ${camelEntityName}s = ${camelEntityName}Mapper.selectByExample(example);
        if (${camelEntityName}s .size() != 1) {
            log.warn("try to find {} with id {}, but find {}","${doEntityName}",id,${camelEntityName}s);
            return null;
        }
        return ${camelEntityName}s.get(0);
</#if>
     }
}
