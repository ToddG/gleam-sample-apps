import * as Ariakit from "@ariakit/react";
import { clsx } from "clsx";
import * as React from "react";

export const Select = React.forwardRef(function Select(
  { children, value, setValue, defaultValue, ...props },
  ref,
) {
  const select = Ariakit.useComboboxStore({
    selectedValue: value,
    setSelectedValue: setValue,
    defaultSelectedValue: defaultValue,
  });
  const portalRef = React.useRef(null);

  // Only call onBlur if the focus is leaving the whole widget.
  const onBlur = (event) => {
    const portal = portalRef.current;
    const { selectElement, popoverElement } = select.getState();
    if (portal?.contains(event.relatedTarget)) return;
    if (selectElement?.contains(event.relatedTarget)) return;
    if (popoverElement?.contains(event.relatedTarget)) return;
    props.onBlur?.(event);
  };

  return (
    <>
      <Ariakit.ComboboxSelect
        ref={ref}
        {...props}
        store={select}
        onBlur={onBlur}
        className={clsx("button", props.className)}
      >
        <Ariakit.ComboboxSelectedValue fallback="Select an item" />
        <Ariakit.ComboboxSelectArrow />
      </Ariakit.ComboboxSelect>
      <Ariakit.ComboboxPopover
        store={select}
        modal
        sameWidth
        gutter={4}
        onBlur={onBlur}
        portalRef={portalRef}
        className="popover"
      >
        {children}
      </Ariakit.ComboboxPopover>
    </>
  );
});

export const SelectItem = React.forwardRef(function SelectItem(props, ref) {
  return (
    <Ariakit.ComboboxItem
      ref={ref}
      {...props}
      className={clsx("select-item", props.className)}
    />
  );
});
