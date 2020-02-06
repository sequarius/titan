<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
package ${basePackageName}.${moduleName}.${domainPackageName};

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

<#list fieldTypePackages as fieldTypePackage>
import ${fieldTypePackage};
</#list>

/**
 * ${displayName}请求实体
 *
 * @author titan-generator
 * @since ${aDate?iso_utc}
 */
@Data
@ApiModel("${displayName}请求实体")
public class ${entityName}RequestDTO {
<#list fieldSpecs as fieldSpec>
    <#if (!fieldSpec.requestDTOIgnore??||!fieldSpec.requestDTOIgnore) && fieldSpec.name!= 'createTime' && fieldSpec.name!= 'updateTime'>

    @ApiModelProperty(value = "${fieldSpec.displayName}"<#if fieldSpec.notNull??> , required = ${fieldSpec.notNull?string('true','false')}</#if>)
    <#if fieldSpec.notNull??&&fieldSpec.notNull>
    @NotNull(message = "${fieldSpec.displayName}为必填项！")
    </#if>
    <#if fieldSpec.maxLength?? && fieldSpec.type.simpleName!= "Date" && fieldSpec.type.simpleName!= "Boolean">
    @Max(value = ${fieldSpec.maxLength}, message = "${fieldSpec.displayName}不能超过${fieldSpec.maxLength}个字符!")
    </#if>
    <#if fieldSpec.minLength?? && fieldSpec.type.simpleName!= "Date" && fieldSpec.type.simpleName!= "Boolean">
    @Min(value = 13, message = "${fieldSpec.displayName}不能小于${fieldSpec.minLength}个字符!")
    </#if>
    <#if fieldSpec.regPatten??>
    @Pattern(regexp = "${fieldSpec.regPatten}", message = "${fieldSpec.regPattenMessage!(fieldSpec.regPatten+'不符合校验规则!')}")
    </#if>
    <#if fieldSpec.type.simpleName == 'Date'>
    @DateTimeFormat(pattern = FormatUtil.DATE_FORMAT_TEMPLATE)
    @JsonFormat(pattern = FormatUtil.DATE_FORMAT_TEMPLATE, timezone = Constant.DEFAULT_TIME_ZONE)
    </#if>
    private ${fieldSpec.type.simpleName} ${fieldSpec.name};
    </#if>
</#list>
}