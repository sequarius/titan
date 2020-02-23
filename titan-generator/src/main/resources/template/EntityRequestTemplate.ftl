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
import org.hibernate.validator.constraints.Length;

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
    <#if fieldSpec.maxLength?? && (fieldSpec.type.simpleName== "Long" || fieldSpec.type.simpleName== "Integer" || fieldSpec.type.simpleName== "BigDecimal" || fieldSpec.type.simpleName== "Byte")>
        <#assign x=fieldSpec.maxLength>
    @Max(value = <#if (x<19)>1<#list 1..x as i>0</#list>L<#else>9223372036854775807L</#if>, message = "${fieldSpec.displayName}不能大于<#if (x<19)>1<#list 1..x as i>0</#list>L<#else>9223372036854775807L</#if>")
    </#if>
    <#if fieldSpec.minLength?? && (fieldSpec.type.simpleName== "Long" || fieldSpec.type.simpleName== "Integer" || fieldSpec.type.simpleName== "BigDecimal" || fieldSpec.type.simpleName== "Byte")>
        <#assign x=fieldSpec.maxLength>
    @Min(value = <#if (x<19)>1<#list 1..x as i>0</#list>L<#else>9223372036854775807L</#if>, message = "${fieldSpec.displayName}不能小于<#if (x<19)>1<#list 1..x as i>0</#list>L<#else>9223372036854775807L</#if>")
    </#if>
    <#if fieldSpec.minLength?? &&!fieldSpec.maxLength?? && fieldSpec.type.simpleName= "String">
    @Length(min = ${fieldSpec.minLength},message = "${fieldSpec.displayName}不能小于${fieldSpec.minLength}个字符!")
    </#if>
    <#if fieldSpec.maxLength?? &&!fieldSpec.minLength?? && fieldSpec.type.simpleName= "String">
    @Length(max = ${fieldSpec.maxLength},message = "${fieldSpec.displayName}不能超过${fieldSpec.maxLength}个字符!")
    </#if>
    <#if fieldSpec.maxLength?? && fieldSpec.minLength?? && fieldSpec.type.simpleName= "String">
    @Length(max = ${fieldSpec.maxLength}, min= ${fieldSpec.minLength} ,message = "${fieldSpec.displayName}长度必须在${fieldSpec.maxLength}-${fieldSpec.maxLength}个字符长度之间!")
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
