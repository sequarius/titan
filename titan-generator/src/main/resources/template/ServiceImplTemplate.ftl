<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
package ${basePackageName}.${moduleName}.${servicePackageName}.impl;

import ${basePackageName}.${domainPackageName}.${doEntityName};
import ${basePackageName}.${domainPackageName}.${doEntityName}Example;
import ${basePackageName}.repository.${doEntityName}Mapper;
import ${commonPackageName}.Page;
import ${basePackageName}.${moduleName}.${domainPackageName}.${entityName}RequestDTO;
import ${basePackageName}.${moduleName}.${domainPackageName}.${entityName}ResponseDTO;
import ${basePackageName}.${moduleName}.${servicePackageName}.${entityName}Service;
import ${commonPackageName}.util.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.util.List;

/**
 * ${displayName} 服务基础实现
 *
 * @author titan-generator
 * @since ${aDate?iso_utc}
 */
@Service
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
    public List<${entityName}ResponseDTO> list${entityName}s(Page page, String keyword) {
        ${doEntityName}Example example = new ${doEntityName}Example();
        example.setPage(page);
        return BeanUtils.copyList(${camelEntityName}Mapper.selectByExample(example), ${entityName}ResponseDTO.class);
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
        ${doEntityName}Example example = new ${doEntityName}Example();
        example.createCriteria().andIdIn(ids);
        return ${camelEntityName}Mapper.deleteByExample(example);
    }
</#if>

    /**
     * 通过id获取DO
     *
     * @param id ${displayName}id
     * @return ${displayName}响应实体
     */
    private ${doEntityName} find${doEntityName}ById(Long id) {
        return ${camelEntityName}Mapper.selectByPrimaryKey(id);
    }
}
