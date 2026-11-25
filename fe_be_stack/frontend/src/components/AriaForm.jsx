import * as Ariakit from "@ariakit/react";
import { clsx } from "clsx";
import * as React from "react";
import { Select } from "../components/AriaSelect.jsx";

export { useFormStore, useFormSubmit } from "@ariakit/react";

export const Form = React.forwardRef(function Form(props, ref) {
  return (
    <Ariakit.Form
      ref={ref}
      {...props}
      className={clsx("wrapper", props.className)}
    />
  );
});

export const FormField = React.forwardRef(function FormField(
  { name, label, children, ...props },
  ref,
) {
  return (
    <div ref={ref} {...props} className={clsx("field", props.className)}>
      <Ariakit.FormLabel name={name}>{label}</Ariakit.FormLabel>
      {children}
      <Ariakit.FormError name={name} className="error" />
    </div>
  );
});

export const FormInput = React.forwardRef(function FormInput(props, ref) {
  return (
    <Ariakit.FormInput
      ref={ref}
      {...props}
      className={clsx("input", props.className)}
    />
  );
});

export const FormSubmit = React.forwardRef(function FormSubmit(props, ref) {
  return (
    <Ariakit.FormSubmit
      ref={ref}
      {...props}
      className={clsx("button primary", props.className)}
    />
  );
});

export const FormSelect = React.forwardRef(function FormSelect(
  { name, ...props },
  ref,
) {
  const form = Ariakit.useFormContext();
  if (!form) throw new Error("FormSelect must be used within a Form");

  const value = Ariakit.useFormValue(form, name);

  const select = (
    <Select
      ref={ref}
      value={value}
      setValue={(value) => form.setValue(name, value)}
      render={props.render}
    />
  );
  const field = <Ariakit.FormControl name={name} render={select} />;
  return <Ariakit.Role.button {...props} render={field} />;
});
